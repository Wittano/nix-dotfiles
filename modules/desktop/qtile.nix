{ config, lib, dotfiles, isDevMode, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode;

  name = "qtile";
  mutableSources = {
    ".config/qtile" = dotfiles.qtile.source;
  };
  desktopApps = [
    "feh"
    "gtk"
    "qt"
    "dunst"
    "picom"
    "tmux"
    "kitty"
    "rofi"
  ];
  autostartPath = ".config/autostart.sh";
  extraConfig = {
    services.xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
