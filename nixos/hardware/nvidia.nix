{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.nvidia.wittano;
in
{
  options.hardware.nvidia.wittano = {
    enable = mkEnableOption "Enable nvidia drivers";
    hostType = mkOption {
      type = types.enum [ "laptop" "pc" ];
      default = "pc";
      description = "Selected Nvidia configuration per host";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = mkIf cfg.enable [ "nvidia" ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

    hardware.nvidia = {
      open = cfg.hostType != "laptop";
      package =
        if cfg.hostType == "laptop"
        then config.boot.kernelPackages.nvidiaPackages.legacy_535
        else config.boot.kernelPackages.nvidia_x11_production;

      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };
}
