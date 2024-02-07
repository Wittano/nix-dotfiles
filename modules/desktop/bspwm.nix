{ config, pkgs, lib, dotfiles, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.bspwm;
  desktopApps = apps.desktopApps config cfg;
in
{

  options.modules.desktop.bspwm = {
    enable = mkEnableOption "Enable BSPWM desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable (mkMerge (with desktopApps; [
    nitrogen
    picom
    gtk
    alacritty
    tmux
    dunst
    rofi
    switchOff
    {
      fonts.packages = with pkgs; [ font-awesome font-awesome_5 siji ];

      home-manager.users.wittano = {
        home = {
          packages = with pkgs; [
            polybar # TODO export polybar config to apps
            gsimplecal
            wmname
          ];

          activation = {
            linkMutableBspwmConfig =
              link.createMutableLinkActivation cfg ".config/bspwm";
            linkMutableSxhkdConfig =
              link.createMutableLinkActivation cfg ".config/sxhkd";
            linkMutablePolybarConfig =
              link.createMutableLinkActivation cfg ".config/polybar";
          };
        };

        xdg.configFile = mkIf (cfg.enableDevMode == false) {
          bspwm.source = dotfiles.config.bspwm.source;
          sxhkd.source = dotfiles.config.sxhkd.source;
          polybar.source = dotfiles.config.polybar.source;
        };
      };

      services.xserver = {
        enable = true;
        windowManager.bspwm.enable = true;
      };
    }
  ]));

}
