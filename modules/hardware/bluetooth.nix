{ config, pkgs, lib, unstable, desktopName, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.bluetooth;
  autostartDesktopModule = attrsets.optionalAttrs (desktopName != "") {
    modules.desktop.${desktopName}.autostartPrograms = [ "${pkgs.blueman}/bin/blueman-applet" ];
  };
in
{
  options = {
    modules.hardware.bluetooth = {
      enable = mkEnableOption ''
        Enable bluetooth
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.bluetooth = {
        enable = true;
        package = unstable.bluez;
      };
      services.blueman.enable = true;
      hardware.enableAllFirmware = true;
    }
    autostartDesktopModule
  ]);
}
