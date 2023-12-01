{ config, pkgs, lib, ... }:
with lib;
with builtins;
let
  cfg = config.modules.hardware.wifi;
  kernel = config.boot.kernelPackages.kernel;
  kernelVersionPackage =
    if (kernel.version == pkgs.linuxPackages_5_15.kernel.version)
    then "linux_5_15"
    else "linux_6_1"; # This driver is working only for kernel 5.18 and lower! 12.11.2023
in
{
  options = {
    modules.hardware.wifi = {
      enable = mkEnableOption "Enable support for WiFi";
      enableTpLink = mkEnableOption "Enable support for WiFi adapter(TpLink)";
    };
  };

  config = mkIf cfg.enable {
    # TODO Fix problem with blocking playing spotify tracks
    networking = {
      networkmanager.enable = true;
      wireless.enable = true;
    };

    boot = mkIf cfg.enableTpLink {
      extraModulePackages = mkIf (!kernel.kernelAtLeast "5.18") [ pkgs.linuxKernel.packages."${kernelVersionPackage}".rtl8192eu ];
      extraModprobeConfig = ''
        blacklist rtl8xxxu
      '';
    };
  };
}
