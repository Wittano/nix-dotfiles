{ config, pkgs, lib, home-manager, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  homeDir = "/home/wittano";
  cfg = config.modules.services.syncthing;
  encryptedConfig =
    builtins.fromJSON (builtins.readFile config.age.secrets.syncthing.path);
in {
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
          folders = encryptedConfig.folders;
          devices = encryptedConfig.devices;
          extraOptions.gui.theme = "dark";
        };
      };
    };
}
