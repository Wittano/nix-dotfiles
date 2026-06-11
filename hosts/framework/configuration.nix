{ config, lib, pkgs, hostname, inputs, secretDir, unstable, master, desktop ? "xmonad", ... }:
with lib;
let
  commonConfig = import ../common.nix {
    inherit lib secretDir master pkgs hostname inputs unstable config;
    desktopName = desktop;
    cores = 8;
  };
  commonHomeManager = import ../common-home-manager.nix {
    inherit inputs pkgs master unstable;
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

    desktop.bspwm.deviceType = "laptop";

    home-manager.users = {
      wittano = mkMerge [
        commonHomeManager
        {
          profile.programming.enable = true;

          xsession.windowManager.bspwm.monitors = {
            "HDMI-0" = [ "I" "II" "III" "IV" "V" ];
          };
          home.packages = with pkgs; [
            krita
          ];
        }
      ];
    };

    services.ly.wittano.enable = true;
  }
]
