{ config, isDevMode, lib, dotfiles, hostname, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode hostname dotfiles;

  name = "xmonad";
  apps = [
    "feh"
    "gtk"
    "qt"
    "dunst"
    "picom"
    "tmux"
    "bluetooth"
    "kitty"
    "rofi"
  ];
  mutableSources = {
    ".config/xmonad" = dotfiles.xmonad.source;
  };
  extraConfig = {
    services.xserver = {
      enable = true;
      # TODO Added steam patches for xmonad to pkgs overlay
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        enableConfiguredRecompile = isDevMode;
      };
    };

    home-manager.users.wittano.programs.xmobar = {
      enable = true;
      extraConfig = mkIf (isDevMode) (builtins.readFile dotfiles.xmonad.xmobarrc.source);
    };
  };
}
