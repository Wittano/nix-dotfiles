{ config, pkgs, lib, ... }:
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

    environment.variables = {
      __NV_PRIME_RENDER_OFFLOAD = "1";
      __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
    };
  };
}
