{ lib, ... }:
with lib;
{
  networking = {
    dhcpcd.enable = mkForce true;
    nameservers = [ "192.168.1.8" ];
  };
}
