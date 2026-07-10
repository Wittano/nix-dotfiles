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
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-12-13th-gen-intel
  ];

  config = lib.mkMerge [
    commonConfig
    {
      users.users.wittano.extraGroups = [
        "wheel"
        "video"
        "render"
      ];

      hardware = {
        bluetooth.wittano.enable = true;
      };

      desktop = {
        bspwm.deviceType = "laptop";
        qtile.profile = "LAPTOP";
      };

      services.xserver.videoDrivers = [ "modesetting" ];

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-vaapi-driver
          intel-media-driver
          vpl-gpu-rt
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD"; # Prefer the modern iHD backend
      };

      # May help if FFmpeg/VAAPI/QSV init fails (esp. on Arc with i915):
      hardware.enableRedistributableFirmware = true;
      boot = {
        tmp.useTmpfs = true;
        kernelParams = [ "i915.force_probe=8086:a7a9" ];
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
              audacity
              kdePackages.kdenlive
            ];

            programs.discord.wittano = {
              enable = true;
              enableAutostart = true;
              type = "discord";
            };
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

      programs.mihoyo = {
        enable = true;
        games = [
          "eepey"
          "honkai-railway"
        ];
      };
    }
  ];
}
