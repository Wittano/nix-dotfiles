{ config, pkgs, ... }: {
  services.xserver = {
    enable = true;
    layout = "pl";
    videoDrivers = [ "nvidia" ];

    # Auto screen-lock
    xautolock = {
      enable = true;
      time = 5;
    };

    # Wacom tablet driver
    wacom.enable = true;

    # Window manager
    windowManager.openbox.enable = true;

    displayManager = {
      defaultSession = "none+openbox";
      gdm.enable = true;
    };
  };
}
