{ config
, lib
, pkgs
, hostname
, inputs
, secretDir
, unstable
, master
, desktop ? "xmonad"
, ...
}:
with lib;
let
  commonConfig = import ../common.nix {
    inherit
      lib
      secretDir
      master
      pkgs
      hostname
      inputs
      unstable
      config
      ;
    desktopName = desktop;
    cores = 8;
  };
  commonHomeManager = import ../common-home-manager.nix {
    inherit
      inputs
      pkgs
      master
      unstable
      ;
    systemVersion = config.system.stateVersion;
    desktopName = desktop;
    inherit (config.catppuccin) accent;
    inherit (config.catppuccin) flavor;
  };
in
lib.mkMerge [
  commonConfig
  {
    boot.tmp.useTmpfs = true;

    users.users.wittano.extraGroups = [ "wheel" ];

    hardware = {
      bluetooth.wittano.enable = true;
    };

    desktop = {
      bspwm.deviceType = "laptop";
      qtile.profile = "LAPTOP";
    };

    home-manager.users = {
      wittano = mkMerge [
        commonHomeManager
        rec {
          profile.programming.enable = true;
          services.polybar.wittano = {
            profile = "laptop";
            wifiAdapter = "wlp0s20f3";
            monitor = "eDP-1";
          };

          xsession.windowManager.bspwm.monitors = {
            "${services.polybar.wittano.monitor}" = [
              "I"
              "II"
              "III"
              "IV"
              "V"
            ];
          };

          home.packages = with pkgs; [
            krita
          ];
        }
      ];
    };

    hardware = {
      virtualization.wittano = {
        enable = true;
        enableExternalStorage = true;
        enableBtrfsStorage = true;
      };
    };

    virtualisation = {
      docker.wittano.enable = true;
    };

    services = {
      ly.wittano.enable = true;
      printers.wittano.enable = true;
    };
  }
]
