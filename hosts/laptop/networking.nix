{ lib, ... }:
with lib;
{
  networking.dhcpcd.enable = mkForce true;
}
