{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.nvidia;
in
{
  options.hardware.nvidia.enable = mkEnableOption "Enable nvidia drivers";

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = mkIf config.services.xserver.enable [ "nvidia" ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

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
