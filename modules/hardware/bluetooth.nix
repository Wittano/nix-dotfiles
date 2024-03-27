{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.bluetooth;
in {
  options = {
    modules.hardware.bluetooth = {
      enable = mkEnableOption ''
        Enable bluetooth
      '';
    };
  };

  config = mkIf cfg.enable {
    modules.desktop.qtile.autostartPrograms = [ "${pkgs.blueman}/bin/blueman-applet" ];

    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    hardware.enableAllFirmware = true;
  };
}
