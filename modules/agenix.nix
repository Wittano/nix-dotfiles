{ config, lib, secretsFile, inputs, ... }:
with lib;
with lib.my;
let privateKeyPath = "/home/wittano/.ssh/syncthing";
in {
  environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

  age = mkIf (config.modules.services.syncthing.enable) {
    identityPaths = [ privateKeyPath ];
    secrets.syncthing.file = secretsFile;
  };
}
