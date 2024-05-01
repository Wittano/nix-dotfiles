{ config, pkgs, lib, dotfiles, isDevMode, hostname, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode hostname;

  name = "openbox";
  mutableSources = {
    ".config/openbox/menu.xml" = dotfiles.openbox."menu.xml".source;
    ".config/openbox/rc.xml" = dotfiles.openbox."rc.xml".source;
    ".config/tint2" = dotfiles.tint2.source;
  };
  apps = [
    "bluetooth"
    "nitrogen"
    "kitty"
    "rofi"
    "gtk"
    "xautolock"
    "dunst"
  ];
  installAutostartFile = false;
  # TODO Update config
  extraConfig = { activationPath, ... }: {
    home-manager.users.wittano = {
      home.packages = with pkgs; [
        openbox-menu
        lxmenu-data
        obconf
        volumeicon
        gsimplecal
        tint2
        # Utils
        arandr
      ];

      xdg.configFile."openbox/autostart".source = activationPath;
    };

    services.xserver = {
      enable = true;
      windowManager.openbox.enable = true;
    };
  };
}

