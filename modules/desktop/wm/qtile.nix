{ config, pkgs, lib, dotfiles, isDevMode, hostname, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode hostname dotfiles;

  name = "qtile";
  mutableSources = {
    ".config/qtile" = dotfiles.qtile.source;
  };
  apps = [
    "feh"
    "bluetooth"
    "gtk"
    "qt"
    "dunst"
    "picom"
    "tmux"
    "kitty"
    "rofi"
  ];
  extraConfig = {
    fonts.packages = with pkgs; [ nerdfonts jetbrains-mono ];

    services.xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
