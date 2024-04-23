{ lib, dotfilesPath, ... }:
with lib;
let
  mkUnlinkerScript = array: ''
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
  mkLinkerSciprt = array: ''
    linkerArray=(${array})

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
  '';
in
{
  # TODO Added checking linked files in previous generation
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

      isAttrsNotEmpty = attrs: builtins.length (builtins.attrNames attrs) != 0;

      mapSourceToFiles = source: attrsets.mapAttrs'
        (n: v:
          let
            type = builtins.typeOf v;
            basename = builtins.baseNameOf n;
            fixedDotfilesPath = builtins.replaceStrings [ ".config" ] [ "" ] n;
            devModeFile =
              if isDevMode && (builtins.pathExists (dotfilesPath + fixedDotfilesPath)) == true
              then "${dotfilesRepo}/dotfiles${fixedDotfilesPath}"
              else v;
            finalFile = if type == "string" then builtins.toFile basename v else devModeFile;
          in
          attrsets.nameValuePair n finalFile)
        source;

      mapLinksToFileContent = links: strings.optionalString
        (isAttrsNotEmpty links)
        (strings.concatStringsSep " " (attrsets.mapAttrsToList (n: v: "'${v} ${n}'") links));

      mapSourceToHomeManagerFiles = files: attrsets.optionalAttrs
        (isAttrsNotEmpty files)
        (builtins.mapAttrs (_: source: { inherit source; }) files);

      homeFiles = mapSourceToFiles homePaths;
      rootFiles = mapSourceToFiles rootPaths;

      linkerArray = strings.optionalString isDevMode (mapLinksToFileContent homeFiles);

      rootLinkerArray = mapLinksToFileContent rootFiles;
      unlinkerArray = mapLinksToFileContent filtredPaths;
    in
    {
      home-manager.users.${username} = {
        home = {
          file = attrsets.optionalAttrs (!isDevMode) (mapSourceToHomeManagerFiles homeFiles);
          activation = {
            cleanUpMutableLinks = hm.dag.entryBefore [ "checkLinkTargets" ] (mkUnlinkerScript unlinkerArray);
            createMutableLinks = mkIf isDevMode (hm.dag.entryAfter [ "linkGeneration" ] (mkLinkerSciprt linkerArray));
          };
        };
      };

      system.userActivationScripts = mkIf (isAttrsNotEmpty rootPaths) {
        linkSystemFiles.text = ''
          ${mkUnlinkerScript rootLinkerArray}

          ${mkLinkerSciprt rootLinkerArray}
        '';
      };
    };
}
