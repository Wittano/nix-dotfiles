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

  enableAutostart = {
    enable = true;
    enableAutostart = true;
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

    programs.kdeconnect.enable = true;

    home-manager.users = {
      wittano = mkMerge [
        commonHomeManager
        {
          profile.programming.enable = true;

          home.packages = with pkgs; [
            remmina
            krita
          ];

          programs = {
            nemo.enable = true;
            telegram = enableAutostart;
            vivaldi.wittano = enableAutostart;
            pomodoro.enable = true;
          };
        }
      ];
    };

    services = {
      ly.wittano.enable = true;
      xserver = {
        enable = true;
        exportConfiguration = true;
        xrandrHeads = [
          {
            output = "HDMI-A-1";
            monitorConfig = ''
              Option "Rotate" "right"
              Option "PreferredMode" "1920x1080"
            '';
          }
          {
            primary = true;
            output = "HDMI-A-0";
            monitorConfig = ''
              Option "PreferredMode" "1920x1080"
            '';
          }
        ];
      };
      boinc.wittano.enable = true;
    };
  }
]
