{ config, lib, pkgs, systemStaff, ... }:

let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.prometheus;
in {
  options = {
    modules.services.prometheus = {
      enable = mkEnableOption ''
        Enable prometheus service
      '';
    };
  };

  # TODO Setup prometheus configuration. Add missing metrics e.g. systemd units metric
  config = mkIf cfg.enable {
    networking.firewall.interfaces.eno1.allowedTCPPorts = [ 9090 9100 ];

    services.prometheus = {
      enable = true;
      port = 9090;

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [ { targets = [ "localhost:9100" ]; } ];
        }
      ];

      exporters = {
        node = {
          enable = true;
          enabledCollectors = [ "textfile" ];
          port = 9100;
        };
      };

    };
  };
}
