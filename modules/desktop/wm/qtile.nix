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
    "tmux"
    "superfile"
    "kitty"
    "rofi"
  ];
  extraConfig = {
    fonts.packages = with pkgs; [ nerdfonts jetbrains-mono ];

    # Configuration development tool
    modules.dev.lang.ides = [ "python" ];

    services.xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
