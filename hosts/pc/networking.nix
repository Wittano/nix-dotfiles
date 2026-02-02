{ lib, ... }:
with lib;
{
  networking = {
    defaultGateway = "192.168.1.1";
    dhcpcd.enable = mkForce true;
    nameservers = [ "192.168.1.8" "1.1.1.1" ];
  };
}
