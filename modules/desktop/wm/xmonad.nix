{ config, isDevMode, lib, dotfiles, hostname, pkgs, unstable, ... }:
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
    "tmux"
    "bluetooth"
    "kitty"
    "superfile"
    "rofi"
  ];
  mutableSources = {
    ".config/xmonad" = dotfiles.xmonad.source;
  };
  extraConfig = {
    services.xserver = {
      enable = true;
      windowManager.xmonad = {
        enable = true;
        haskellPackages = unstable.haskellPackages;
        enableConfiguredRecompile = isDevMode;
      };
    };

    environment.systemPackages = with pkgs; [ cabal-install ];

    modules.dev.lang.ides = [ "haskell" ];

    home-manager.users.wittano.programs.xmobar = {
      enable = true;
      package = unstable.xmobar;
      extraConfig = mkIf (isDevMode) (builtins.readFile dotfiles.xmonad.xmobarrc.source);
    };
  };
}
