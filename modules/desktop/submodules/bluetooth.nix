{ unstable, ... }: {
  autostart = [ "blueman-applet" ];

  onlyFor = [ "pc" ];

  config = {
    hardware.bluetooth = {
      enable = true;
      package = unstable.bluez;
    };

    modules.hardware.virtualization.stopServices = [{
      name = "win10";
      services = [ "bluetooth.service" ];
    }];

    services.blueman.enable = true;
    hardware.enableAllFirmware = true;
  };
}
