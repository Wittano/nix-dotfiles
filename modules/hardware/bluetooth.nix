{ config, pkgs, lib, unstable, desktopName, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.bluetooth;
in
{
  options = {
    modules.hardware.bluetooth = {
      enable = mkEnableOption ''
        Enable bluetooth
      '';
    };
  };

  config = mkIf cfg.enable {
    modules.desktop.${desktopName}.autostartPrograms = [ "${pkgs.blueman}/bin/blueman-applet" ];

    hardware.bluetooth = {
      enable = true;
      package = unstable.bluez;
    };
    services.blueman.enable = true;
    hardware.enableAllFirmware = true;
  };
}
