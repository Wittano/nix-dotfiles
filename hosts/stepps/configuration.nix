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

      services = {
        xserver.videoDrivers = [ "modesetting" ];
        teamviewer.wittano = {
          enable = true;
          enableRemoteAccount = true;
        };
      };

      boot.tmp.useTmpfs = true;

      home-manager.users = {
        wittano = mkMerge [
          commonHomeManager
          {
            profile.programming.enable = true;

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

      programs.steam.wittano = {
        enable = true;
        disk.enable = true;
      };
    }
  ];
}
