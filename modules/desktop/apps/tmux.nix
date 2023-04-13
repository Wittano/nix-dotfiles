{ config, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.tmux;
in {
  # TODO Replace NixOS module by extension attribute 
  options.modules.desktop.apps.tmux = {
    enable = mkEnableOption "Enable tmux";

    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ tmux ];

        activation.linkMutableTmuxConfig =
          link.createMutableLinkActivation {
            internalPath = ".tmux.conf";
            isDevMode = cfg.enableDevMode;
          };

        file = mkIf (cfg.enableDevMode == false) {
          ".tmux.conf".source = dotfiles.".tmux.conf".source;
        };
      };
    };
  };
}
