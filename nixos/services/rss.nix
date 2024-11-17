{ config, lib, ... }:
with lib;
with lib.my;
{
  options.services.rss.enable = mkEnableOption "Enable commafeed - RSS server";

  config = mkIf config.services.rss.enable {
    services.commafeed.enable = true;

    hardware.virtualization.wittano.stopServices = [
      {
        name = "win10";
        services = [
          config.systemd.services.commafeed.name
        ];
      }
    ];

    networking.firewall.allowedTCPPorts = [ 8082 ];
  };
}
