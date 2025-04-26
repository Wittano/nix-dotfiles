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

    users.users.wittano.extraGroups = [ "wheel" ];

    home-manager.users.wittano = mkMerge [
      commonHomeManager
      {
        home.packages = with pkgs; [
          telegram-desktop
          discord
          pavucontrol
        ];

        profile.programming.enable = true;
        programs.jetbrains.ides = mkForce [ "go" "haskell" ];
      }
    ];

    console = {
      earlySetup = true;
      useXkbConfig = true;
    };

    hardware = {
      trackpoint.emulateWheel = true;

      samba.enable = true;
      printers.wittano.enable = true;
    };
  }
]
