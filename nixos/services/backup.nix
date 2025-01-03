{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.services.backup;
  path = "/etc/ssh/restic.key";
  exclude = [
    "VirtualBox*"
    "Games/***"
    ".ansible"
    "*cache*"
    ".dotnet"
    ".m2"
    "*pnpm*"
    ".gradle"
    ".java"
    ".jdks"
    ".npm"
    ".vagrant.d"
    ".rustup"
    ".nuget"
    ".emacs.d"
    ".paradoxlauncher"
    ".local/share/Steam/***"
    ".local/share/virtualenvs"
    ".local/share/JetBrains"
    ".local/share/*-launcher"
    ".local/share/bottles"
    ".local/share/PrismaLauncher"
    ".local/share/openttd"
    ".local/share/lutris"
    ".local/share/Trash"
    "**/*/node_modules"
    ".cache/nix"
    ".cache/spotify/Data"
    "**/*/*Cache"
    "**/*/Cache*"
    "**/*/Cache"
    "**/*/venv"
    "**/*/CMakeFiles"
    "**/*/.idea"
    ".steam"
    "go/**/*"
    "git"
    ".sbt"
    ".osu"
    ".xlore"
    ".sikiko"
    ".tor project"
  ];
in
{
  options = {
    services.backup = {
      enable = mkEnableOption "Enable Backup service";
      device = mkOption {
        type = types.str;
        default = "/dev/disk/by-label/BACKUP";
        description = "Path to backup parition device";
        example = "/dev/disk/by-label/BACKUP_VOL_1";
      };
      format = mkOption {
        type = types.str;
        default = "ext4";
        description = "Device partition format e.g. ext4, ntfs or zfs";
        example = "ntfs";
      };
      location = mkOption {
        type = types.str;
        default = "/mnt/backup";
        description = "Path to backup parition device";
        example = "/mnt/devices/backup";
      };
      directory = mkOption {
        type = types.str;
        default = "/mnt/backup/wittano.nixos";
        example = "/home/$USER/backup";
        description = "Directory, which contain your backup";
      };
    };
  };

  config = mkIf cfg.enable {
    fileSystems."${cfg.location}" = {
      inherit (cfg) device;

      fsType = cfg.format;
    };

    home-manager.users.wittano.gtk.gtk3.bookmarks = [
      "file://${cfg.directory} Current Backup"
      "file://${cfg.location} Backup device"
    ];

    services.openssh.hostKeys = [{
      inherit path;
      bits = 4096;
      type = "rsa";
    }];

    system.activationScripts.resticKeyChangeOwner = "chown wittano ${path} ${path}.pub";

    services.restic.backups.home = {
      inherit exclude;

      pruneOpts = [ "--keep-weekly 4" ];
      user = "wittano";
      repository = cfg.directory;
      paths = [ config.home-manager.users.wittano.home.homeDirectory ];
      passwordFile = path;
      timerConfig = {
        OnBootSec = "15m";
        OnUnitActiveSec = "1d";
        Persistent = true;
      };
      initialize = true;
    };
  };
}

