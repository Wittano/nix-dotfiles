{ config, lib, pkgs, hostname, inputs, unstable, master, ... }:
with lib;
with lib.my;
let
  desktopName = "xmonad";
  commonConfig = import ../common.nix {
    inherit desktopName master config lib hostname pkgs unstable inputs;
    cores = 4;
    users = [ "wittano" ];
  };
  commonHomeManager = import ../common-home-manager.nix {
    inherit inputs pkgs;
    systemVersion = config.system.stateVersion;
    accent = config.catppuccin.accent;
    flavor = config.catppuccin.flavor;
  };
in
mkMerge [
  commonConfig
  {
    virtualisation.podman.wittano.enable = true;

    home-manager.users.wittano = mkMerge [
      commonHomeManager
      {
        profile.programming.enable = true;
      }
    ];

    hardware = {
      trackpoint.emulateWheel = true;

      samba.enable = true;
      printers.wittano.enable = true;
    };
  }
]
