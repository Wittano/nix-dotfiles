{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.nvidia.wittano;

  packages = {
    "pc" = config.boot.kernelPackages.nvidia_x11_production;
    "laptop" = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
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
    services.xserver.videoDrivers = [ "nvidia" ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    environment.sessionVariables.VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

    users.users.wittano.extraGroups = [ "video" ];

    hardware = {
      graphics.enable = true;
      nvidia = {
        open = cfg.hostType != "laptop";
        package = packages."${cfg.hostType}";

        modesetting.enable = true;
        nvidiaSettings = true;
      };
    };
  };
}
