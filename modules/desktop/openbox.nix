{ config, pkgs, lib, dotfiles, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.openbox;
  nitrogenConfig = import ./apps/nitrogen.nix { inherit pkgs dotfiles home-manager; };
in {

  options.modules.desktop.openbox = {
    enable = mkEnableOption "Enable Openbox desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable (mkMerge [ nitrogenConfig
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

          # Utils
          arandr
          lxappearance
          nitrogen
        ];

        activation = let
          customeActivation = path: link.createMutableLinkActivation { internalPath = path; isDevMode = cfg.enableDevMode; };
        in {
          linkMutableOpenboxConfig = customeActivation ".config/openbox";
          linkMutableTint2Config = customeActivation ".config/tint2";
        };
      };

      xdg.configFile = let
        configDir = dotfiles.".config";
      in mkIf (cfg.enableDevMode == false) {
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
          notifier = ''${pkgs.libnotify}/bin/notify-send "Locking in 10 seconds"'';
        };

        windowManager.openbox.enable = true;
        displayManager.defaultSession = "none+openbox";
	      displayManager.gdm.enable = true;
      };

      picom = {
        enable = true;
        fade = false;
      };
    };
  }]);

}
