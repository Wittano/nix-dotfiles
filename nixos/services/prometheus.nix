{ config, lib, ... }:
with lib;
with lib.my;
{
  options.services.prometheus.wittano.enable = mkEnableOption "prometheus service";

  config = mkIf config.services.prometheus.wittano.enable {
    networking.firewall.interfaces.eno1.allowedTCPPorts = [ 9090 9100 ];

    services.prometheus = {
      enable = true;
      port = 9090;

      scrapeConfigs = [{
        job_name = "node";
        static_configs = [{ targets = [ "localhost:9100" ]; }];
      }];

      exporters.node = {
        enable = true;
        enabledCollectors = [ "textfile" "cgroups" "ksmd" "processes" "systemd" ];
        port = 9100;
      };
    };
  };
}
