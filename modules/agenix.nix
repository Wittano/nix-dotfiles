{ config, agenix, lib, secretsFile, ... }:
with lib;
with lib.my;
let
  privateKeyPath = "/home/wittano/.ssh/syncthing";
in
{
  environment.systemPackages = [ agenix.packages.x86_64-linux.default ];

  age = mkIf (config.modules.services.syncthing.enable) {
    identityPaths = [ privateKeyPath ];
    secrets.syncthing.file = secretsFile;
  };
}
