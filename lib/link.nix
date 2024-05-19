{ lib, dotfilesPath, pkgs, ... }:
with lib;
let
  linkerFileName = "linker";

  isAttrsNotEmpty = attrs: builtins.length (builtins.attrNames attrs) != 0;

  mapLinksToFileContent = links: strings.optionalString
    (isAttrsNotEmpty links)
    (strings.concatStringsSep " " (attrsets.mapAttrsToList (n: v: "'${v} ${n}'") links));

  mkUnlinkerScript = array:
    let
      unlinkFileScript = pkgs.writeScript "unlinkFile.sh" /*bash*/ ''
        while read -r path; do
          if [ -h "$path" ]; then
            unlink "$path"
          fi
        done <"$1"
      '';
    in
      /*bash*/ ''
      find /nix/store -maxdepth 1 -type f -iname '*${linkerFileName}' -print | xargs ${unlinkFileScript} || echo "Something goes wrong with unlining files from previous generations"

      unlinkerArray=(${array})
      for LINE in "''${unlinkerArray[@]}"; do
        DEST=$(echo "$LINE" | cut -d ' ' -f 2)
        if [[ "$DEST" != /* ]]; then
          DEST="$HOME/$DEST"
        fi

        if [ -h "$DEST" ]; then
          unlink "$DEST"
        fi
      done
    '';
  mkLinkerSciprt = mutableLinks: username:
    let
      content = builtins.filter
        (x: !(strings.hasPrefix builtins.storeDir x))
        (builtins.map
          (x:
            if !(strings.hasPrefix "/" x)
            then "/home/${username}/" + x
            else x
          )
          (builtins.attrNames mutableLinks));

      genFile = builtins.toFile linkerFileName (builtins.concatStringsSep "\n" content);
      linkerArray = mapLinksToFileContent mutableLinks;
    in
      /*bash*/''
      linkerArray=(${linkerArray})

      for LINE in "''${linkerArray[@]}"; do
        SRC=$(echo "$LINE" | cut -d ' ' -f 1)
        DEST=$(echo "$LINE" | cut -d ' ' -f 2)
        if [[ "$DEST" != /* ]]; then
          DEST="$HOME/$DEST"
        fi

        if [ -f "$DEST" ]; then
          mv "$DEST" "$DEST.old"
        fi

        ln -s "$SRC" "$DEST"
      done

      if [ ! -f ${genFile} ]; then
        echo "failed found ${genFile} file"
        exit 1
      fi
    '';
in
{
  mkMutableLinks =
    { config
    , isDevMode ? false
    , paths ? { }
    , username ? "wittano"
    , dotfilesRepo ? config.environment.variables.NIX_DOTFILES # path or string to dotfiles directory
    }:
    let
      filtredPaths = attrsets.filterAttrs
        (n: v:
          let
            type = builtins.typeOf v;
            condition = type == "string" || type == "path" || type == "set";
          in
          debug.traceIf (!condition) "Ignored value for ${n}. Invalid type: ${type}" condition)
        paths;

      rootPaths = attrsets.filterAttrs (n: _: strings.hasPrefix "/" n) filtredPaths;
      homePaths = attrsets.filterAttrs (n: _: !(strings.hasPrefix "/" n)) filtredPaths;

      mapSourceToFiles = source: attrsets.mapAttrs'
        (n: v:
          let
            type = builtins.typeOf v;
            basename = builtins.baseNameOf n;
            fixedPath = strings.removePrefix "." (
              let
                split = strings.splitString "/" n;
              in
              if builtins.length split > 1
              then builtins.concatStringsSep "/" (builtins.tail split)
              else n
            );
            # TODO search resursive files in directiores
            dotfilesSourcePath = dotfilesPath + "/${fixedPath}";
            devModeFile =
              if isDevMode && (builtins.pathExists dotfilesSourcePath) == true
              then "${dotfilesRepo}/dotfiles/${fixedPath}"
              else v;
            finalFile = if type == "string" then builtins.toFile basename v else devModeFile;
          in
          attrsets.nameValuePair n finalFile)
        source;

      mapSourceToHomeManagerFiles = files: attrsets.optionalAttrs
        (isAttrsNotEmpty files)
        (builtins.mapAttrs (_: source: { inherit source; }) files);

      homeFiles = mapSourceToFiles homePaths;
      rootFiles = mapSourceToFiles rootPaths;

      rootLinkerArray = mapLinksToFileContent rootFiles;
      unlinkerArray = mapLinksToFileContent filtredPaths;
    in
    {
      home-manager.users.${username} = {
        home = {
          file = attrsets.optionalAttrs (!isDevMode) (mapSourceToHomeManagerFiles homeFiles);
          activation = {
            cleanUpMutableLinks = hm.dag.entryBefore [ "checkLinkTargets" ] (mkUnlinkerScript unlinkerArray);
            createMutableLinks = mkIf isDevMode (hm.dag.entryAfter [ "linkGeneration" ] (mkLinkerSciprt homeFiles username));
          };
        };
      };

      system.userActivationScripts = mkIf (isAttrsNotEmpty rootPaths) {
        linkSystemFiles.text = ''
          ${mkUnlinkerScript rootLinkerArray}

          ${mkLinkerSciprt rootFiles username}
        '';
      };
    };
}
