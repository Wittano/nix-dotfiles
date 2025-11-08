{ config, lib, pkgs, hostname, inputs, secretDir, unstable, master, desktop ? "xmonad", ... }:
with lib;
let
  commonConfig = import ../common.nix {
    inherit lib secretDir master pkgs hostname inputs unstable;
    desktopName = desktop;
    cores = 24;
  };
  commonHomeManager = import ../common-home-manager.nix {
    inherit inputs pkgs master unstable;
    systemVersion = config.system.stateVersion;
    desktopName = desktop;
    inherit (config.catppuccin) accent;
    inherit (config.catppuccin) flavor;
  };

  inherit (pkgs) remmina;# VNC client
in
lib.mkMerge [
  commonConfig
  {
    environment.systemPackages = with pkgs; [ keymapp wally-cli ];
    boot.tmp.useTmpfs = true;

    desktop.${desktop}.users = [ "wittano" ];

    users.users.wittano.extraGroups = [ "wheel" ];

    hardware = {
      keyboard.zsa.enable = true;
      virtualization.wittano = {
        enable = true;
        enableWindowsVM = true;
      };
      amd.enable = true; # AMD GPU
      samba.enable = true; # Local network SAMAB server 
      bluetooth.wittano.enable = true;
    };

    virtualisation.docker.wittano.enable = true;

    home-manager.users = {
      wittano = mkMerge [
        commonHomeManager
        {
          profile.programming.enable = true;

          home.packages = with pkgs; [
            remmina
            krita
            tor-browser-bundle-bin
          ];

          programs = {
            telegram.enable = true;
            vivaldi.enable = true;
            pomodoro.enable = true;
            games = {
              enable = true;
              enableDev = true;
            };
            lutris.wittano.enable = true;
          };
        }
      ];
    };

    programs = {
      # droidcam.enable = true; # FIXME Problem with sharing Video phone <-> pc. ONLY ON LINUX
      steam.wittano = {
        enable = true;
        disk.enable = true;
      };
      mihoyo = {
        enable = true;
        games = [ "honkai-railway" ];
      };
    };

    services = {
      teamviewer.enable = true;
      redis.wittano.enable = false;
      prometheus.wittano.enable = false;
      backup.path = "sftp:backup:/mnt/hdd/backup/nixos";
      xserver = {
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
