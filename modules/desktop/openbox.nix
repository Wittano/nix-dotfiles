{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.openbox;
  
  linkMutableConfig = name:
    hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -L $HOME/.config/${name} ]; then
        ln -s $DOTFILES/.config/${name} $HOME/.config/${name}
      fi
    '';
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

        activation = {
          linkOpenboxConfig = linkMutableConfig "openbox";
          linkNitrogenConfig = linkMutableConfig "nitrogen";
          linkTint2Config = linkMutableConfig "tint2";
        };
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
