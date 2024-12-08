{ config, lib, ... }:
with lib;
with lib.my;
let
  windowsExporterConfig = attrsets.optionalAttrs config.hardware.virtualization.wittano.enableWindowsVM
    {
      job_name = "windows_exporter";
      static_configs = [{
        targets = [ "192.168.122.110:9182" ];
      }];
    };
in
{
  options.services.prometheus.wittano.enable = mkEnableOption "prometheus service";

  config = mkIf config.services.prometheus.wittano.enable {
    networking.firewall.interfaces.eno1.allowedTCPPorts = [ 9090 9100 ];

    services.prometheus = rec {
      enable = true;
      port = 9090;

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [{ targets = [ "localhost:${builtins.toString exporters.node.port}" ]; }];
        }
        windowsExporterConfig
      ];

      exporters.node = {
        enable = true;
        enabledCollectors = [ "textfile" "cgroups" "ksmd" "processes" "systemd" ];
        port = 9100;
      };
    };
  };
}
