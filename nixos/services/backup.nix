{ config, lib, hostname, ... }:
with lib;
with lib.my;
let
  cfg = config.services.backup;
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
  options.services.backup.enable = mkEnableOption "Enable Backup service";

  config = mkIf cfg.enable {
    services.restic.backups.home = {
      inherit exclude;

      pruneOpts = [ "--keep-weekly 4" ];
      repository = "sftp:backup:/mnt/backup/nixos.${hostname}";
      paths = [ "/home/wittano" ];
      timerConfig = {
        OnBootSec = "15m";
        OnUnitActiveSec = "1d";
        Persistent = true;
      };
      passwordFile = "/etc/nixos/restic-password";
      initialize = true;
    };
  };
}

