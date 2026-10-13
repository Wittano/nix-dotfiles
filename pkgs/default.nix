{ pkgs, ... }:
{
  nixos-blur-playmouth = pkgs.callPackage ./plymouth/theme/nixos-blur-playmouth { };
  bluetooth-menu-generator = pkgs.callPackage ./bluetooth-menu-generator { };
  wget-2-zim = pkgs.callPackage ./wget-2-zim { };
}
