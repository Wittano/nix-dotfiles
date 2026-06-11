{ config, lib, pkgs, hostname, inputs, secretDir, unstable, master, desktop ? "xmonad", ... }:
with lib;
let
  commonConfig = import ../common.nix {
    inherit lib secretDir master pkgs hostname inputs unstable config;
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

  enableAutostart = {
    enable = true;
    enableAutostart = true;
  };

  inherit (pkgs) remmina;# VNC client
in
lib.mkMerge [
  commonConfig
  {
    environment.systemPackages = with pkgs; [ keymapp wally-cli ];
    boot.tmp.useTmpfs = true;

    users.users.wittano.extraGroups = [ "wheel" ];

    hardware = {
      trackpoint.emulateWheel = true;
      keyboard.zsa.enable = true;
      virtualization.wittano = {
        enable = true;
        enableExternalStorage = true;
      };
      amd.enable = true; # AMD GPU
      samba.enable = true; # Local network SAMAB server 
      nfs-client.enable = true; # Local network NFS server
      bluetooth.wittano.enable = true;
    };

    programs.kdeconnect.enable = true;

    home-manager.users = {
      wittano = mkMerge [
        commonHomeManager
        {
          systemd.user.tmpfiles.rules = [
            "d /home/wittano/Downloads 0755 wittano users 7d"
          ];

          profile.programming.enable = true;

          home.packages = with pkgs; [
            remmina
            krita
          ];

          programs = {
            pomodoro.enable = true;
            games.enable = true;
          };
        }
      ];
    };

    programs = {
      steam.wittano = enableAutostart // {
        disk.enable = true;
      };
      mihoyo = {
        enable = true;
        games = [ "honkai-railway" ];
      };
    };

    services = {
      backup.enable = true;
      ly.wittano.enable = true;
      backup.path = "sftp:backup:/mnt/hdd/backup/nixos";
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
