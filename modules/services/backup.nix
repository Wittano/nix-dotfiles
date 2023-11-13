{ config, pkgs, lib, username, systemStaff, ... }:
let
  inherit (lib) mkEnableOption types mkIf mkOption;

  cfg = config.modules.services.backup;
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
        Backup service for ${username} home directory
      '';
      serviceConfig = {
        Type = "oneshot";
        User = username;
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.backupDir}
        chown ${username}:users ${cfg.backupDir}
      '';
      script = ''
        today=$(${pkgs.coreutils}/bin/date -I)
        base_dir=$(${pkgs.coreutils}/bin/dirname ${cfg.backupDir})
        archive_backup="$base_dir/wittano.backup-$today.tar"

        if [ -f $archive_backup ]; then
          ${pkgs.coreutils}/bin/echo "Backup for '$today' has already created"
          exit 0
        fi

        remove_oldest_backup() {
          oldest_backup=$(${pkgs.findutils}/bin/find /mnt/backup -maxdepth 1 -name wittano.backup-*.tar -type f -printf '%T+ %p\n' | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/head -1 | ${pkgs.coreutils}/bin/cut -d' ' -f2-)
          if [ -n "$oldest_backup" ]; then
            ${pkgs.coreutils}/bin/rm $oldest_backup
          else
            ${pkgs.coreutils}/bin/echo "The oldest backup wasn't found"
          fi        
        }

        remove_failed_backup() {
          ${pkgs.coreutils}/bin/echo "Failed to create backup. Check if you have space enough on disk"
          if [ -f $archive_backup ]; then
            ${pkgs.coreutils}/bin/rm $archive_backup
          fi
        }

        ${pkgs.rsync}/bin/rsync -aAX --delete --exclude-from="${systemStaff.scripts.backup."exclude.txt".source}" "$HOME" ${cfg.backupDir}

        ${pkgs.gnutar}/bin/tar -c --use-compress-program=${pkgs.pigz}/bin/pigz -f $archive_backup ${cfg.backupDir} && remove_oldest_backup || remove_failed_backup
      '';
    };
  };

}

