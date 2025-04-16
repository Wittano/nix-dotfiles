{ config, lib, pkgs, hostname, inputs, unstable, master, ... }:
with lib;
with lib.my;
let
  desktopName = "bspwm";
  commonConfig = import ../common.nix { inherit desktopName master config lib hostname pkgs unstable inputs; cores = 4; };
in
mkMerge [
  commonConfig
  {
    virtualisation.podman.wittano.enable = true;

    desktop.bspwm.deviceType = "laptop";

    hardware = {
      trackpoint.emulateWheel = true;

      samba.enable = true;
      printers.wittano.enable = true;
    };
  }
]
