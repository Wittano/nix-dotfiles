{ config, lib, pkgs, hostname, inputs, unstable, master, ... }:
with lib;
let
  desktopName = "xmonad";
  commonConfig = import ../common.nix { inherit lib master pkgs hostname inputs unstable desktopName; cores = 24; };
  commonHomeManager = import ../common-home-manager.nix {
    inherit inputs pkgs master;
    systemVersion = config.system.stateVersion;
    inherit (config.catppuccin) accent;
    inherit (config.catppuccin) flavor;
  };

  inherit (pkgs) remmina;# VNC client
  dropbox = pkgs.dropbox-cli; # Dropbox CLI
  inherit (pkgs) czkawka;
  inherit (pkgs) pandoc;
in
lib.mkMerge [
  commonConfig
  rec {
    environment.systemPackages = with pkgs; [ keymapp wally-cli ];

    virtualisation.docker.wittano = {
      enable = true;
      user = "wito";
    };

    desktop.${desktopName}.users = [ "wittano" "wito" "work" ];

    users.users = {
      wito = {
        isNormalUser = true;
        uid = mkDefault 1001;
        extraGroups = [ "wheel" ];
        shell = pkgs.fish;
      };
      work = {
        isNormalUser = true;
        uid = mkDefault 1002;
        shell = pkgs.fish;
      };
    };

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

    virtualisation.podman.wittano.enable = true;

    home-manager.users = {
      wittano = mkMerge [
        commonHomeManager
        {
          home.packages = with pkgs; [
            remmina
            dropbox
            czkawka
            pandoc
            krita
            master.freetube
            discord
            spotify
          ];

          programs = {
            games.enable = true;
            lutris.enable = true;
          };

          desktop.autostart.programs = [
            "telegram-desktop -startintray"
            "discord --start-minimized"
            "spotify"
            "steam -silent"
          ];
        }
      ];
      wito = mkMerge [
        commonHomeManager
        {
          home.packages = with pkgs; [ remmina dropbox postman czkawka signal-desktop ];
          profile.programming.enable = true;
        }
      ];
      work = mkMerge [
        commonHomeManager
        {
          home.packages = [ remmina czkawka ];
          profile.work.enable = true;
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
        enable = false;
        games = [ "honkai-railway" ]; # FIXME Failed download rustls during nix build 
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
