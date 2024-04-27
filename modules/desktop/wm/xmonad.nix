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
    ".config/xmonad" = dotfiles.xmonad.source;
  };
  autostartPath = ".config/autostart.sh";
  extraConfig = {
    services.xserver = {
      enable = true;
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
