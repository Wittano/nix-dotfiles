{ config, lib, pkgs, hostname, inputs, unstable, master, secretDir, ... }:
with lib;
with lib.my;
let
  desktopName = "xmonad";
  commonConfig = import ../common.nix {
    inherit desktopName master config lib hostname pkgs unstable inputs secretDir;
    cores = 4;
    users = [ "wittano" ];
  };
  commonHomeManager = import ../common-home-manager.nix {
    inherit inputs pkgs master;
    systemVersion = config.system.stateVersion;
    inherit (config.catppuccin) accent;
    inherit (config.catppuccin) flavor;
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

    programs.nix-ld.enable = true;
    console.earlySetup = true;

    hardware = {
      trackpoint.emulateWheel = true;

      samba.enable = true;
      printers.wittano.enable = true;
    };
  }
]
