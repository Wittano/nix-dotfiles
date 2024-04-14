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
    .sbt
    .osu
    .xlore
    .sikiko
    .tor project
  '';
in
{
  options = {
    modules.services.backup = {
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
      device = cfg.device;
      fsType = cfg.format;
    };

    home-manager.users.wittano.gtk.gtk3.bookmarks = [
      "file://${cfg.directory} Current Backup"
      "file://${cfg.location} Backup device"
    ];

    systemd.timers.backup.timerConfig = {
      OnBootSec = "15m";
      Unit = "backup.service";
      OnUnitActiveSec = "1d";
    };
    systemd.services.backup = {
      description = "Backup service for wittano home directory";
      serviceConfig = {
        Type = "oneshot";
        User = "wittano";
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.directory}
        chown wittano:users ${cfg.directory}
      '';
      path = with pkgs; [ coreutils gnutar findutils rsync pigz ];
      # TODO Move script to shell file
      script = ''
        today=$(date -I)
        base_dir=${cfg.location}
        archive_backup="$base_dir/wittano.backup-$today.tar"

        if [ -f $archive_backup ]; then
          echo "Backup for '$today' has already created"
          exit 0
        fi

        create_archive() {
          tar -c --use-compress-program="pigz --best --recursive" -f $archive_backup ${cfg.directory}
        }

        close_app() {
          echo "Backup for '$today' wasn't created!"
          exit -1
        }

        remove_oldest_backup() {
          oldest_backup=$(find ${cfg.location} -maxdepth 1 -name wittano.backup-*.tar -type f -printf '%T+ %p\n' | sort | head -1 | cut -d' ' -f2-)
          oldest_backup_name="$(basename $oldest_backup)"

          if [[ -n "$oldest_backup" && "$oldest_backup_name" != "wittano.backup-$today.tar" ]]; then
            rm $oldest_backup
          else
            echo "The oldest backup wasn't found"
          fi
        }

        remove_failed_backup() {
          echo "Failed to create backup. Check if you have space enough on disk"

          remove_oldest_backup
         
          create_archive || close_app
        }

        resync() {
          remove_oldest_backup

          rsync -aAX --delete --exclude-from="${excludedList}" "$HOME" ${cfg.directory}

          create_archive || remove_failed_backup
        }

        rsync -aAX --delete --exclude-from="${excludedList}" "$HOME" ${cfg.directory} || resync

        create_archive || remove_failed_backup
      '';
    };
  };

}

