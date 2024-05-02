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

  # TODO check if WiFi adapter works
  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;

    boot = mkIf cfg.enableTpLink {
      kernelPackages = mkForce pkgs.linuxPackages;
      extraModulePackages = [ config.boot.kernelPackages.rtl8192eu ];
      extraModprobeConfig = "blacklist rtl8xxxu";
    };
  };
}
