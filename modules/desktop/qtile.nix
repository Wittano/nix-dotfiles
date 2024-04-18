{ config, pkgs, lib, dotfiles, privateRepo, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.qtile;
  desktopApps = desktop.mkAppsSet { inherit config cfg; };
  autostartScript = desktop.mkAutostart "qtile" cfg.autostartPrograms;

  devMode = desktop.mkDevMode config cfg {
    ".config/qtile" = dotfiles.qtile.source;
    ".config/autostart.sh" = autostartScript;
  };
in
{
  options.modules.desktop.qtile = desktop.mkDesktopOption { inherit devMode; };

  config = mkIf (cfg.enable) (mkMerge (with desktopApps; [
    feh
    gtk
    qt
    dunst
    picom
    tmux
    kitty
    rofi
    devMode.config
    {
      services.xserver = {
        enable = true;
        windowManager.qtile.enable = true;
      };
    }
  ]));
}
