{ config, pkgs, lib, dotfiles, privateRepo, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.qtile;
  desktopApps = apps.desktopApps config cfg;
  autostartScript = desktop.mkAutostart "qtile" cfg.autostartPrograms;
in
{
  options.modules.desktop.qtile = {
    enable = mkEnableOption "Enable Qtile desktop";
  } // (desktop.mkAutostartOption "qtile");

  config = mkIf (cfg.enable) (mkMerge (with desktopApps; [
    feh
    gtk
    qt
    dunst
    picom
    tmux
    kitty
    rofi
    {
      home-manager.users.wittano = {
        home.activation.linkMutableQtileConfig = link.createMutableLinkActivation cfg "qtile";

        xdg.configFile = {
          qtile.source = dotfiles.qtile.source;
          "autostart.sh".source = autostartScript;
        };
      };

      services.xserver = {
        enable = true;
        windowManager.qtile.enable = true;
      };
    }
  ]));
}
