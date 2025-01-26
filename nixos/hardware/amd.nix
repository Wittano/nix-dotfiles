{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.amd;
in
{
  options.hardware.amd.enable = mkEnableOption "Enable AMD drivers";

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = mkIf config.services.xserver.enable [ "amdgpu" ];

    boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
