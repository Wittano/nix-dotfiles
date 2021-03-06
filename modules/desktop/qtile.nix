{ config, pkgs, lib, dotfiles, unstable, ... }:
with lib;
with lib.my;
let 
  cfg = config.modules.desktop.qtile;
  displayManager = pkgs.callPackage ./display-manager.nix {};
in {

  options.modules.desktop.qtile = {
    enable = mkEnableOption "Enable Qtile desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [
          notify-osd-customizable
          notify-desktop

          # Utils
          arandr
          lxappearance
          nitrogen
        ];

        activation = let
          customeActivation = path:
            link.createMutableLinkActivation {
              internalPath = path;
              isDevMode = cfg.enableDevMode;
            };
        in {
          linkMutableQtileConfig = customeActivation ".config/qtile";
        };
      };

      xdg.configFile = let configDir = dotfiles.".config";
      in mkIf (cfg.enableDevMode == false) {
        qtile.source = configDir.qtile.source;
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

        windowManager.qtile.enable = true;
      };

      picom = {
        enable = true;
        fade = false;
      };

    } // displayManager.gdm;
  };

}
