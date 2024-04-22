{ config, isDevMode, lib, dotfiles, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode;

  name = "xmonad";
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
  mutableSources = {
    ".xmonad" = dotfiles.xmonad.source;
  };
  extraConfig = {
    services.xserver = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        enableConfiguredRecompile = isDevMode;
      };
    };
  };
}
