{ config, lib, inputs, secretDir, ... }:
with lib;
with lib.my;
let
  storeKeys = "/home/wittano/.ssh";
  sshDir =
    if builtins.pathExists storeKeys
    then builtins.readDir storeKeys
    else { };

  privateKeys = attrsets.filterAttrs (n: _: (lib.strings.hasSuffix "age" n)) sshDir;
  privateKeyNames = attrsets.mapAttrsToList (n: _: builtins.replaceStrings [ ".age" ] [ "" ] n) privateKeys;
  privateKeysPaths = attrsets.mapAttrsToList (n: _: "${storeKeys}/${n}") privateKeys;

  ageFiles = attrsets.mapAttrs'
    (n: _:
      let
        name = builtins.replaceStrings [ ".age" ] [ "" ] n;
        ageFileName = lists.findFirst (v: strings.hasPrefix name v) (throw "Missing required age file: '${n}'") privateKeyNames;
      in
      {
        inherit name;

        value = secretDir + "/${ageFileName}.age";
      })
    (builtins.readDir secretDir);

  secrets = attrsets.mapAttrs'
    (n: v: {
      name = n;
      value = {
        file = v;
      };
    })
    ageFiles;
in
{
  warnings = lists.optionals (!builtins.pathExists storeKeys) [
    "Missing ${storeKeys} directory"
  ];

  environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

  age = mkIf ((builtins.pathExists storeKeys) && config.modules.services.syncthing.enable) {
    inherit secrets;

    identityPaths = privateKeysPaths;
  };
}
