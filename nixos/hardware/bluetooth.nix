{ config, lib, unstable, ... }:
with lib;
{
  options.hardware.bluetooth.wittano.enable = mkEnableOption "custom bluethooth bluetooth";

  config = mkIf config.hardware.bluetooth.wittano.enable {
    hardware.bluetooth = {
      enable = true;
      package = unstable.bluez;
    };

    hardware.virtualization.wittano.stopServices = [{
      name = "win10";
      services = [ "bluetooth.service" ];
    }];

    services.blueman.enable = true;
    hardware.enableAllFirmware = true;
  };
}
