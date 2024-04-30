{ config, pkgs, lib, dotfiles, isDevMode, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode;

  name = "openbox";
  mutableSources = {
    ".config/openbox" = dotfiles.openbox.source;
    ".config/tint2" = dotfiles.tint2.source;
  };
  desktopApps = [
    "nitrogen"
    "kitty"
    "rofi"
    "gtk"
    "xautolock"
    "dunst"
  ];
  # TODO Update config
  extraConfig = {
    home-manager.users.wittano.home.packages = with pkgs; [
      openbox-menu
      lxmenu-data
      obconf
      volumeicon
      gsimplecal
      tint2
      # Utils
      arandr
    ];

    services.xserver = {
      enable = true;
      windowManager.openbox.enable = true;
    };
  };
}

