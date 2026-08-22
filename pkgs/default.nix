{ pkgs, ... }:
{
  nixos-blur-playmouth = pkgs.callPackage ./plymouth/theme/nixos-blur-playmouth { };
  bluetooth-menu-generator = pkgs.callPackage ./bluetooth-menu-generator { };
}
