{ lib, ... }:
with lib;
{
  networking = {
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.167";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.1";
    dhcpcd.enable = mkForce true;
    nameservers = [ "192.168.1.8" ];
  };
}
