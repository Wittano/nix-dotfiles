{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.backup;

  excludedList = builtins.toFile "exclude.txt" ''
    VirtualBox*
    Games/***
    .ansible
    *cache*
    .dotnet
    .m2
    *pnpm*
    .gradle
    .java
    .jdks
    .npm
    .vagrant.d
    .rustup
    .nuget
    .emacs.d
    .paradoxlauncher
    .local/share/Steam/***
    .local/share/virtualenvs
    .local/share/JetBrains
    .local/share/*-launcher
    .local/share/bottles
    .local/share/PrismaLauncher
    .local/share/openttd
    .local/share/lutris
    .local/share/Trash
    **/*/node_modules
    **/*/venv
    **/*/CMakeFiles
    **/*/.idea
    .steam
    go/**/*
    git
  '';
in
{
  options = {
    modules.services.backup = {
      enable = mkEnableOption "Enable Backup service";
      backupDir = mkOption {
        type = types.str;
        default = "/mnt/backup";
        example = "/home/$USER/backup";
        description = ''
          Directory, which contain your backup
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.timers.backup.timerConfig = {
      OnCalendar = "*-*-* *:00:00";
      Unit = "backup.service";
      OnUnitActiveSec = "1d";
    };
    systemd.services.backup = {
      description = ''
        Backup service for wittano home directory
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "wittano";
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.backupDir}
        chown wittano:users ${cfg.backupDir}
      '';
      script = ''
        today=$(${pkgs.coreutils}/bin/date -I)
        base_dir=$(${pkgs.coreutils}/bin/dirname ${cfg.backupDir})
        archive_backup="$base_dir/wittano.backup-$today.tar"

        if [ -f $archive_backup ]; then
          ${pkgs.coreutils}/bin/echo "Backup for '$today' has already created"
          exit 0
        fi

        create_archive() {
          ${pkgs.gnutar}/bin/tar -c --use-compress-program=${pkgs.pigz}/bin/pigz -f $archive_backup ${cfg.backupDir}
        }

        close_app() {
          ${pkgs.coreutils}/bin/echo "Backup for '$today' wasn't created!"
          exit -1
        }

        remove_oldest_backup() {
          oldest_backup=$(${pkgs.findutils}/bin/find /mnt/backup -maxdepth 1 -name wittano.backup-*.tar -type f -printf '%T+ %p\n' | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/head -1 | ${pkgs.coreutils}/bin/cut -d' ' -f2-)
          oldest_backup_name=$(${pkgs.coreutils}/bin/basename $oldest_backup)

          if [[ -n "$oldest_backup" && "$oldest_backup_name" != "wittano.backup-$today.tar" ]]; then
            ${pkgs.coreutils}/bin/rm $oldest_backup
          else
            ${pkgs.coreutils}/bin/echo "The oldest backup wasn't found"
          fi
        }

        remove_failed_backup() {
          ${pkgs.coreutils}/bin/echo "Failed to create backup. Check if you have space enough on disk"

          remove_oldest_backup
         
          create_archive || close_app
        }

        resync() {
          remove_oldest_backup

          ${pkgs.rsync}/bin/rsync -aAX --delete --exclude-from="${excludedList}" "$HOME" ${cfg.backupDir}

          create_archive || remove_failed_backup
        }

        ${pkgs.rsync}/bin/rsync -aAX --delete --exclude-from="${excludedList}" "$HOME" ${cfg.backupDir} || resync

        create_archive || remove_failed_backup
      '';
    };
  };

}

