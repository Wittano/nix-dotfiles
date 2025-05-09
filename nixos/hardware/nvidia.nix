{ config, lib, ... }:
with lib;
with lib.my;
{
  options.hardware.nvidia.wittano.enable = mkEnableOption "Enable nvidia drivers";

  config = mkIf config.hardware.nvidia.wittano.enable {
    services.xserver.videoDrivers = mkIf config.services.xserver.enable [ "nvidia" ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidia_x11_production;
      modesetting.enable = true;
    };
  };
}
