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
    warnings = lists.optional (cfg.enableTpLink) [
      "Module modules.hardware.wifi force change your kernel to stable version ${pkgs.linuxPackages.kernel.version}"
    ];

    networking.networkmanager.enable = true;

    # Development fixs and features for drivers
    modules.dev.lang.ides = [ "cpp" ];

    boot = mkIf cfg.enableTpLink {
      kernelPackages = mkForce pkgs.linuxPackages;
      extraModulePackages = [ config.boot.kernelPackages.rtl8192eu ];
      extraModprobeConfig = "blacklist rtl8xxxu";
    };
  };
}
