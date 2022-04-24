{ config, pkgs, lib, dotfiles, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.openbox;
in {

  options.modules.desktop.openbox = {
    enable = mkEnableOption "Enable Openbox desktop";
  };

  config = mkIf cfg.enable {
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

          # Utils
          arandr
          lxappearance
          nitrogen
        ];

      };

      xdg.configFile = let
        configDir = dotfiles.".config";
      in {
        openbox.source = configDir.openbox.source;
        tint2.source = configDir.tint2.source;
      };
    };

    services = {
      xserver = {
        enable = true;

        xautolock = {
          enable = true;
          time = 15;
          enableNotifier = true;
          notifier =
            ''${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds"'';
        };

        windowManager.openbox.enable = true;

        displayManager = {
          defaultSession = "none+openbox";
          gdm.enable = true;
        };
      };

      picom = {
        enable = true;
        fade = false;
      };

    };
  };

}
