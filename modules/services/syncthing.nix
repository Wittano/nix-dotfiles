{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.syncthing;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;

  encryptedConfig =
    if builtins.pathExists config.age.secrets.syncthing.path then
      trivial.pipe config.age.secrets.syncthing.path [
        builtins.readFile
        builtins.fromJSON
      ] else debug.traceValFn (x: "Missing decrypted syncthing configuration. Load default empty config") { };
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
