{ config, pkgs, lib, dotfiles, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.openbox;

  importApp = name: apps.importApp cfg name;

  nitrogenConfig = importApp "nitrogen";
  terminalConfig = importApp "alacritty";
  rofiConfig = importApp "rofi";
  gtkConfig = importApp "gtk";
  xautolockConfig = importApp "xautolock";
in {

  options.modules.desktop.openbox = {
    enable = mkEnableOption "Enable Openbox desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    nitrogenConfig
    terminalConfig
    xautolockConfig
    gtkConfig
    rofiConfig
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
            notify-osd-customizable
            picom-jonaburg

            # Utils
            arandr
          ];

          activation = let
            customeActivation = path:
              link.createMutableLinkActivation {
                internalPath = path;
                isDevMode = cfg.enableDevMode;
              };
          in {
            linkMutableOpenboxConfig = customeActivation ".config/openbox";
            linkMutableTint2Config = customeActivation ".config/tint2";
            linkMutablePicomConfig = customeActivation ".config/picom";
          };
        };

        xdg.configFile = let configDir = dotfiles.".config";
        in mkIf (cfg.enableDevMode == false) {
          openbox.source = configDir.openbox.source;
          tint2.source = configDir.tint2.source;
          picom.source = configDir.picom.source;
        };

      };

      services.xserver = {
        enable = true;

        windowManager.openbox.enable = true;
      };
    }
  ]);

}
