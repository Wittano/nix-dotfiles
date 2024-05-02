{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.syncthing;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;

  encryptedConfig =
    builtins.fromJSON (builtins.readFile config.age.secrets.syncthing.path);
in
{
  options = {
    modules.services.syncthing = {
      enable = mkEnableOption "Enable syncthing deamon";
    };
  };

  config =
    mkIf (cfg.enable) {
      services.syncthing = {
        enable = builtins.pathExists config.age.secrets.syncthing.path;
        systemService = true;
        dataDir = "${homeDir}/.cache/syncthing";
        configDir = "${homeDir}/.config/syncthing";
        user = "wittano";
        settings = {
          folders = encryptedConfig.folders or { };
          devices = encryptedConfig.devices or { };
          extraOptions.gui.theme = "dark";
        };
      };
    };
}
