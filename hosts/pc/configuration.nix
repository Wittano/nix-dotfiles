{ config, lib, pkgs, hostname, inputs, unstable, master, ... }:
let
  commonConfig = import ../common.nix { inherit config lib master pkgs hostname inputs unstable; cores = 24; };
in
lib.mkMerge [
  commonConfig
  rec {
    hardware = {
      keyboard.zsa.enable = true;
      virtualization.wittano = {
        enable = true;
        users = [ "wittano" "wito" ];
        enableWindowsVM = false;
      };
      amd.enable = true; # AMD GPU
      samba.enable = true; # Local network SAMAB server 
      printers.wittano.enable = true;
      bluetooth.wittano.enable = true;
    };

    home-manager.users.wittano.programs = {
      games.enable = true;
      lutris.enable = true;
    };

    environment.systemPackages = with pkgs; [ openfortivpn ];

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
      redis.wittano.enable = true;
      prometheus.wittano.enable = true;
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
      boinc.wittano.enable = !hardware.virtualization.wittano.enableWindowsVM;
    };
  }
]
