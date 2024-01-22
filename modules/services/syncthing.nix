{ config, pkgs, lib, home-manager, ... }:
with lib;
let
  homeDir = "/home/wittano";
  cfg = config.modules.services.syncthing;
  encryptedConfig = attrsets.optionalAttrs
    (config.age.secrets ? syncthing)
    (builtins.fromJSON (builtins.readFile config.age.secrets.syncthing.path));
in
{
  options = {
    modules.services.syncthing = {
      enable = mkEnableOption ''
        Enable syncthing deamon
      '';
    };
  };

  config =
    mkIf (cfg.enable && builtins.pathExists config.age.secrets.syncthing.path) {
      services.syncthing = rec {
        enable = true;
        systemService = true;
        dataDir = "${homeDir}/.cache/syncthing";
        configDir = "${homeDir}/.config/syncthing";
        user = "wittano";
        settings = {
          folders = attrsets.optionalAttrs (encryptedConfig ? folders) encryptedConfig.folders;
          devices = attrsets.optionalAttrs (encryptedConfig ? devices) encryptedConfig.devices;
          extraOptions.gui.theme = "dark";
        };
      };
    };
}
