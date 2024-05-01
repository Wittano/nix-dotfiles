{ pkgs, unstable, ... }: {
  autostart = [{
    name = "blueman-applet";
    path = with pkgs; [ blueman ];
    script = "blueman-applet";
  }];

  onlyFor = [ "pc" ];

  config = {
    hardware.bluetooth = {
      enable = true;
      package = unstable.bluez;
    };
    services.blueman.enable = true;
    hardware.enableAllFirmware = true;
  };
}
