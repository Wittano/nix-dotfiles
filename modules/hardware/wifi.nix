{ config, pkgs, lib, home-manager, ownPackages, ... }:
with lib;
with builtins;
let
  cfg = config.modules.hardware.wifi;
  kernel = config.boot.kernelPackages.kernel;
  kernelVersionPackage =
    if (kernel.version == pkgs.linuxPackages_5_15.kernel.version)
    then "linux_5_15"
    else "linux_6_1"; # This driver is working for kernel 5.18 and lower! 01.10.2023
in
{
  options = {
    modules.hardware.wifi = {
      enable = mkEnableOption "Enable support for WiFi";
      enableTpLink = mkEnableOption "Enable support for WiFi adapter(TpLink)";
    };
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    boot.extraModulePackages = mkIf (cfg.enableTpLink && !kernel.kernelAtLeast "5.18") [ pkgs.linuxKernel.packages."${kernelVersionPackage}".rtl8192eu ];
    boot.extraModprobeConfig = mkIf cfg.enableTpLink ''
      blacklist rtl8xxxu
    '';
  };
}
