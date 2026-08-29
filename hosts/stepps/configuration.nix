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
    cores = 4;
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
        bluetooth.wittano.enable = true;
      };

      desktop = {
        bspwm.deviceType = "laptop";
        qtile.profile = "LAPTOP";
      };

      services.xserver.videoDrivers = [ "modesetting" ];

      boot.tmp.useTmpfs = true;

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

            programs.discord.wittano = {
              enable = true;
              enableAutostart = true;
              type = "discord";
            };
          }
        ];
      };

      virtualisation.docker.wittano.enable = true;

      services.ly.wittano.enable = true;
    }
  ];
}
