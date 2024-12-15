{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.amd;
in
{
  options.hardware.amd.enable = mkEnableOption "Enable nvidia drivers";

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = mkIf config.services.xserver.enable [ "amd" ];

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
