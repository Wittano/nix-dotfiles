{ config, pkgs, lib, dotfiles, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.openbox;
  desktopApps = apps.desktopApps config cfg;
in {

  options.modules.desktop.openbox = {
    enable = mkEnableOption "Enable Openbox desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable (mkMerge (with desktopApps; [
    nitrogen
    alacritty
    rofi
    gtk
    xautolock
    dunst
    {
      home-manager.users.wittano = {
        home = {
          packages = with pkgs; [
            openbox-menu
            lxmenu-data
            obconf
            tint2
            volumeicon
            gsimplecal

            # Utils
            arandr
          ];

          activation = {
            linkMutableOpenboxConfig =
              link.createMutableLinkActivation cfg ".config/openbox";
            linkMutableTint2Config =
              link.createMutableLinkActivation cfg ".config/tint2";
          };
        };

        xdg.configFile = let configDir = dotfiles.".config";
        in mkIf (cfg.enableDevMode == false) {
          openbox.source = configDir.openbox.source;
          tint2.source = configDir.tint2.source;
        };

      };

      services.xserver = {
        enable = true;

        windowManager.openbox.enable = true;
      };
    }
  ]));

}
