{ config, pkgs, lib, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.nvidia;
in
{
  options = {
    modules.hardware.nvidia = {
      enable = mkEnableOption ''
        Enable nvidia drivers
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [ nvtop ];

    services.xserver.videoDrivers = mkIf config.services.xserver.enable [ "nvidia" ];

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        setLdLibraryPath = true;
        extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
      };

      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;
      };
    };
  };
}
