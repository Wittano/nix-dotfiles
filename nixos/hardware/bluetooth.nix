{ config, lib, unstable, ... }:
with lib;
{
  options.hardware.bluetooth.wittano.enable = mkEnableOption "custom bluethooth bluetooth";

  config = mkIf config.hardware.bluetooth.wittano.enable {
    hardware = {
      virtualization.wittano.stoppedServices = [
        "bluetooth.service"
      ];

      bluetooth = {
        enable = true;
        package = unstable.bluez;
      };

      enableAllFirmware = true;
    };

    services.blueman.enable = true;
  };
}
