{ config, lib, pkgs, hostname, inputs, unstable, ... }:
let
  commonConfig = import ../common.nix { inherit config lib pkgs hostname inputs unstable; cores = 24; };
in
lib.mkMerge [
  commonConfig
  rec {
    hardware = {
      keyboard.zsa.enable = true;
      virtualization.wittano = {
        enable = false;
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
      xserver.xrandrHeads = [
        {
          primary = true;
          output = "DVI-D-0";
          monitorConfig = ''
            Option "PreferredMode" "1920x1080"
          '';
        }
        {
          primary = false;
          output = "HDMI-0";
          monitorConfig = ''
            Option "PreferredMode" "1920x1080"
            Option "RightOf" "DVI-D-0"
          '';
        }
      ];

      boinc.wittano.enable = !hardware.virtualization.wittano.enableWindowsVM;
      rss.enable = true;
    };
  }
]
