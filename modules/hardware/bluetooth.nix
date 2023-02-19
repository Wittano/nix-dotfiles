{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

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
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
    hardware.enableAllFirmware = true;
  };
}
