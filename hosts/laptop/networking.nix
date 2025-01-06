{ lib, ... }:
with lib;
{
  networking = {
    dhcpcd.enable = mkForce true;
    wifi.wittano.enable = true;
  };
}
