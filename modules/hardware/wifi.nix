{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.wifi;
in
{
  options = {
    modules.hardware.wifi = {
      enable = mkEnableOption "Enable support for WiFi";
      enableTpLink = mkEnableOption "Enable support for WiFi adapter(TpLink)";
    };
  };

  config = mkIf cfg.enable {
    warnings = [{
      warning = cfg.enableTpLink && config.boot.kernelPackages != pkgs.linuxPackages;
      message = "Mofule modules.hardware.wifi force change your kernel to stable version ${pkgs.linuxPackages.kernel.version}";
    }];

    networking.networkmanager.enable = true;

    boot = mkIf cfg.enableTpLink {
      kernelPackages = mkForce pkgs.linuxPackages;
      extraModulePackages = [ config.boot.kernelPackages.rtl8192eu ];
      extraModprobeConfig = "blacklist rtl8xxxu";
    };
  };
}
