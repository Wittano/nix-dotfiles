{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.desktop.gaming;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;
  steamGamingDir = if cfg.disk.enable then cfg.disk.path else "${homeDir}/.steam/steam";
  gamingDisk = "/dev/disk/by-label/GAMING";

  fixGamingDisk = pkgs.writeShellApplication {
    name = "fix-gaming-disk";
    runtimeInputs = with pkgs; [ sudo ntfs3g ];
    text = ''
      sudo umount ${gamingDisk}
      sudo ntfsfix ${gamingDisk}
      sudo mount -a
    '';
  };
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
    home-manager.users.wittano = {
      gtk.gtk3.bookmarks = mkIf cfg.disk.enable [ "file://${steamGamingDir} Gaming" ];
      home.packages = [ fixGamingDisk ];
    };

    boot.supportedFilesystems.ntfs = mkForce cfg.disk.enable;

    fileSystems = mkIf cfg.disk.enable {
      "${steamGamingDir}" = {
        device = gamingDisk;
        fsType = "ntfs-3g";
        options = [ "rw" "uid=1000" ];
      };
    };
  };
}
