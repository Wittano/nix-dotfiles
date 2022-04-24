{ config, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rofi;
in {
  options.modules.desktop.apps.rofi = {
    enable = mkEnableOption "Enable rofi";

    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ rofi ];

        activation.linkMutableRofiConfig =
          link.createMutableLinkActivation {
            internalPath = ".config/rofi";
            isDevMode = cfg.enableDevMode;
          };
      };

      xdg.configFile = mkIf (cfg.enableDevMode == false) {
        rofi.source = dotfiles.".config".rofi.source;
      };
    };
  };
}
