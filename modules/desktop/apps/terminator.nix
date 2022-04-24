{ config, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.terminator;
in {
  options.modules.desktop.apps.terminator = {
    enable = mkEnableOption "Enable terminator";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable {
    environment.variables.TERM = "terminator";

    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ terminator ];


        activation.linkMutableTerminatorConfig =
          link.createMutableLinkActivation {
            internalPath = ".config/terminator";
            isDevMode = cfg.enableDevMode;
          };
      };

      xdg.configFile = mkIf (cfg.enableDevMode == false) {
        terminator.source = dotfiles.".config".terminator.source;
      };
    };
  };
}
