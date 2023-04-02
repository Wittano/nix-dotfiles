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
    systemd.services.backup = {
      description = ''
        Backup service for ${username} home directory
      '';
      serviceConfig = {
        Type = "oneshot";
        User = username;
      };
      startAt = "*-*-* 20:00:00";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p ${cfg.backupDir}
        chown ${username}:users ${cfg.backupDir}
      '';
      # TODO Add automaticlly archivzation backups
      script = ''
        ${pkgs.rsync}/bin/rsync -aAX --delete --exclude-from="${systemStaff.scripts.backup."exclude.txt".source}" "$HOME" ${cfg.backupDir}
      '';
    };
  };

}

