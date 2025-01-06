{ config, lib, pkgs, hostname, inputs, unstable, ... }:
with lib;
with lib.my;
let
  desktopName = "bspwm";
  commonConfig = import ../common.nix { inherit desktopName config lib hostname pkgs unstable inputs; cores = 4; };
in
mkMerge [
  commonConfig
  {
    virtualisation.docker.wittano.enable = true;

    desktop.bspwm.deviceType = "laptop";

    hardware = {
      trackpoint.emulateWheel = true;
      keyboard.zsa.enable = true;

      nvidia.enable = true;
      samba.enable = true;
      printers.wittano.enable = true;
    };
  }
]
