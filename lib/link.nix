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
  mkMutableLinks = config: isDevMode: paths:
    let
      filtredPaths = attrsets.filterAttrs
        (n: v:
          let
            type = builtins.typeOf v;
            condition = type == "string" || type == "path" || type == "set";
          in
          debug.traceIf (!condition) "Ignored value for ${n}. Invalid type: ${type}" condition)
        paths;

      rootPaths = attrsets.filterAttrs (n: v: strings.hasPrefix "/" n) filtredPaths;
      configPaths = attrsets.filterAttrs (n: v: strings.hasPrefix ".config" n) filtredPaths;
      homePaths = attrsets.filterAttrs (n: v: !(strings.hasPrefix ".config" n) && !(strings.hasPrefix "/" n)) filtredPaths;

      isAttrsNotEmpty = attrs: builtins.length (builtins.attrNames attrs) != 0;

      mapSourceToFiles = source: attrsets.mapAttrs'
        (n: v:
          let
            type = builtins.typeOf v;
            basename = builtins.baseNameOf n;
            fixedDotfilesPath = builtins.replaceStrings [ ".config/" ] [ "" ] n;
            devModeFile =
              if isDevMode && (builtins.pathExists (dotfilesPath + fixedDotfilesPath)) == true
              then "${config.environment.variables.NIX_DOTFILES}/dotfiles/${fixedDotfilesPath}"
              else v;
            finalFile = if type == "string" then builtins.toFile basename v else devModeFile;
          in
          attrsets.nameValuePair fixedDotfilesPath finalFile)
        source;

      mapLinksToFileContent = links: strings.optionalString
        (isAttrsNotEmpty links)
        (strings.concatStringsSep " " (attrsets.mapAttrsToList (n: v: "'${v} ${n}'") links));

      mapSourceToHomeManagerFiles = files: attrsets.optionalAttrs
        (isAttrsNotEmpty files)
        (builtins.mapAttrs (_: v: { source = v; }) files);

      homeFiles = mapSourceToFiles homePaths;
      rootFiles = mapSourceToFiles rootPaths;
      configFiles = mapSourceToFiles configPaths;

      linkerArray =
        let
          homeLinks = mapLinksToFileContent homeFiles;
          configLinks = mapLinksToFileContent configFiles;
        in
        strings.optionalString isDevMode (homeLinks + " " + configLinks);

      rootLinkerArray = mapLinksToFileContent rootFiles;
      unlinkerArray = mapLinksToFileContent filtredPaths;
    in
    {
      home-manager.users.wittano = {
        home = {
          file = attrsets.optionalAttrs (!isDevMode) (mapSourceToHomeManagerFiles homeFiles);
          activation = {
            cleanUpMutableLinks = hm.dag.entryBefore [ "linkGeneration" ] (mkUnlinkerScript unlinkerArray);
            createMutableLinks = mkIf isDevMode (hm.dag.entryAfter [ "linkGeneration" ] (mkLinkerSciprt linkerArray));
          };
        };
        xdg.configFile = attrsets.optionalAttrs (!isDevMode) (mapSourceToHomeManagerFiles configFiles);
      };

      system.userActivationScripts = mkIf (isAttrsNotEmpty rootPaths) {
        linkSystemFiles.text = ''
          ${mkUnlinkerScript rootLinkerArray}

          ${mkLinkerSciprt rootLinkerArray}
        '';
      };
    };
}
