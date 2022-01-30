{ config, pkgs, lib, ... }:
let openbox = (import ./desktop/openbox.nix { inherit config pkgs; });
in {
  imports =
    [ (lib.mkIf config.services.xserver.windowManager.openbox.enable openbox) ];

  services.xserver = {
    enable = true;
    layout = "pl";
    videoDrivers = [ "nvidia" ];

    # Auto screen-lock
    xautolock = {
      enable = !config.services.xserver.desktopManager.gnome.enable;
      time = 15;
      enableNotifier = true;
      notifier = ''${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds"'';
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
