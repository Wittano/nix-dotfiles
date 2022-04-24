{ config, lib, pkgs, systemStaff, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.cron;
in {
  options = {
    modules.services.cron = {
      enable = mkEnableOption ''
        Enable cron scheduler
      '';
    };
  };

  config = mkIf cfg.enable {
    services.cron = {
      enable = true;
      systemCronJobs = [
        "@daily   wittano   ${pkgs.bash}/bin/bash ${systemStaff.scripts.backup."backup.sh".source}"
      ];
    };
  };
}
