{ config, pkgs, lib, dotfiles, privateRepo, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.qtile;
  desktopApps = apps.desktopApps config cfg;
in
{
  options.modules.desktop.qtile = {
    enable = mkEnableOption "Enable Qtile desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf (cfg.enable) (mkMerge (with desktopApps; [
    nitrogen
    gtk
    dunst
    ranger
    picom
    tmux
    kitty
    rofi
    {
      home-manager.users.wittano = {
        home.activation.linkMutableQtileConfig =
          link.createMutableLinkActivation cfg "qtile";

        xdg.configFile = mkIf (cfg.enableDevMode == false) {
          qtile.source = dotfiles.qtile.source;
        };
      };

      services.xserver = {
        enable = true;
        windowManager.qtile.enable = true;
      };
    }
  ]));

}
