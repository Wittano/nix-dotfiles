{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.prometheus;
in
{
  options = {
    modules.services.prometheus = {
      enable = mkEnableOption "Enable prometheus service";
    };
  };

  config = mkIf cfg.enable {
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
