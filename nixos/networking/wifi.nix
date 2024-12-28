{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.networking.wifi.wittano;
in
{
  options.networking.wifi.wittano = {
    enable = mkEnableOption "Enable support for WiFi";
    enableTpLink = mkEnableOption "Enable support for WiFi adapter(TpLink)";
  };

  config = mkIf cfg.enable {
    warnings = lists.optional cfg.enableTpLink [
      "Module modules.hardware.wifi force change your kernel to stable version ${pkgs.linuxPackages.kernel.version}"
    ];

    networking.networkmanager.enable = true;

    boot = mkIf cfg.enableTpLink {
      kernelPackages = mkForce pkgs.linuxPackages;
      extraModulePackages = [ config.boot.kernelPackages.rtl8192eu ];
      extraModprobeConfig = "blacklist rtl8xxxu";
    };
  };
}
