{
  config,
  lib,
  pkgs,
  hostname,
  inputs,
  secretDir,
  unstable,
  master,
  desktop ? "xmonad",
  ...
}:
with lib;
let
  desktopName = desktop;
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
    cores = 4;
  };
in
{
  config = lib.mkMerge [
    commonConfig
    {
      zramSwap.enable = true;

      # Nix configuration
      nix = {
        settings.auto-optimise-store = mkForce false;
        extraOptions = mkForce "experimental-features = nix-command flakes pipe-operators";
      };

      users.users.wittano.extraGroups = [
        "wheel"
        "video"
        "render"
      ];

      hardware = {
        block.scheduler."sd[a-c][0-9]" = "bfq";
        enableRedistributableFirmware = true;
        virtualization.wittano.enable = true;
        nvidia.wittano = {
          enable = true;
          hostType = "laptop";
        };
        graphics.extraPackages = [ pkgs.intel-media-driver ];
        bluetooth.wittano.enable = true;
      };

      desktop = {
        bspwm.deviceType = "laptop";
        qtile.profile = "LAPTOP";
      };

      services = {
        xserver = {
          videoDrivers = [ "modesetting" ];
          deviceSection = ''
            Option "TearFree" "true"
          '';
        };
        teamviewer.wittano = {
          enable = true;
          enableRemoteAccount = true;
        };
      };

      boot.tmp.useTmpfs = true;

      home-manager.users.wittano = {
            imports = [
              inputs.catppuccin.homeModules.catppuccin
              inputs.nixvim.homeModules.nixvim
              ./../../home-manager
            ];

            home = {
              stateVersion = config.system.stateVersion;
              packages = with pkgs; [
                # Utils
                textsnatcher # Text extractor

                # Folder Dialog menu
                zenity

                # Web browser
                firefox

                # Utils
                eog # Image viewer
                libreoffice # Office staff

                # Apps
                keepassxc # Password manager

                # Security
                keepassxc
              ];
            };

            programs = {
              nemo.enable = true;
              thunderbird.wittano.enable = true;
              file-roller.enable = true;
              git.wittano.enable = true;
              btop.enable = true;
              ghostty.wittano.enable = true;
              signal = {
                enable = true;
                enableAutostart = true;
              };
              joplin.enable = true;
              telegram = {
                enable = true;
                enableAutostart = true;
              };
              fish = {
                wittano = {
                  enable = true;
                  enableDirenv = true;
                };
                shellAliases.open = "xdg-open";
              };
              rofi.wittano = {
                inherit desktopName;

                enable = true;
              };
              mpv.enable = true;
            };

            qt.wittano.enable = true;
            gtk.wittano.enable = true;

            catppuccin = {
              accent = "pink";
              flavor = "latte";
              enable = true;
            };

            desktop.autostart.enable = true;

            profile.programming.enable = true;
      };

      virtualisation.docker.wittano.enable = true;

      services.ly.wittano.enable = true;

      programs.steam.wittano = {
        enable = true;
        disk.enable = true;
      };
    }
  ];
}
