{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.gaming;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;
  steamGamingDir = if cfg.disk.enable then cfg.disk.path else "${homeDir}/.steam/steam";
in
{
  options = {
    modules.desktop.gaming = {
      enable = mkEnableOption "Enable games";
      disk = {
        enable = mkEnableOption "Add special disk to configuration";
        path = mkOption {
          type = types.str;
          default = "/mnt/gaming";
          description = "Path to mounted additional disk";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.gtk.gtk3.bookmarks = mkIf cfg.disk.enable [ "file://${steamGamingDir} Gaming" ];

    fileSystems = mkIf cfg.disk.enable {
      "${steamGamingDir}" = {
        device = "/dev/disk/by-label/GAMING";
        fsType = "ext4";
      };
    };
  };
}
