{ config, pkgs, lib, dotfiles, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.openbox;
  desktopApps = apps.desktopApps config cfg;
in
{

  options.modules.desktop.openbox = {
    enable = mkEnableOption "Enable Openbox desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable (mkMerge (with desktopApps; [
    nitrogen
    kitty
    rofi
    gtk
    xautolock
    tint2
    dunst
    {
      home-manager.users.wittano = {
        home = {
          packages = with pkgs; [
            openbox-menu
            lxmenu-data
            obconf
            volumeicon
            gsimplecal

            # Utils
            arandr
          ];

          activation.linkMutableOpenboxConfig = link.createMutableLinkActivation cfg "openbox";
        };

        xdg.configFile = mkIf (cfg.enableDevMode == false) {
          openbox.source = dotfiles.openbox.source;
        };

      };

      services.xserver = {
        enable = true;
        windowManager.openbox.enable = true;
      };
    }
  ]));

}
