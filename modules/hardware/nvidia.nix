{ config, pkgs, lib, home-manager, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.hardware.nvidia;
in {
  options = {
    modules.hardware.nvidia = {
      enable = mkEnableOption ''
        Enable nvidia drivers
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [ nvtop ];

    services.xserver.videoDrivers =
      mkIf config.services.xserver.enable [ "nvidia" ];

    services.boinc.extraEnvPackages = mkIf config.services.boinc.enable
      (with pkgs; [ linuxPackages.nvidia_x11 ]);

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        setLdLibraryPath = true;
        extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      };

      nvidia.modesetting.enable = true;
    };
  };
}
