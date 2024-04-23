{ config, lib, ... }:
with lib;
with lib.my;
let
  homeDir = "/home/wittano";
  cfg = config.modules.services.syncthing;
  encryptedConfig =
    if (config.age.secrets ? syncthing)
    then
      attrsets.optionalAttrs (builtins.pathExists config.age.secrets.syncthing.path)
        (builtins.fromJSON (builtins.readFile config.age.secrets.syncthing.path))
    else null;
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
    mkIf (cfg.enable && encryptedConfig != null) {
      services.syncthing = {
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
