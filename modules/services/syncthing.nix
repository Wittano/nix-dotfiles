{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.syncthing;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;

  encryptedConfig = trivial.pipe config.age.secrets.syncthing.path [
    builtins.readFile
    builtins.fromJSON
  ];
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
        enable = true;
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
