{ pkgs, home-manager, lib, dotfiles, cfg, ... }:
with lib;
with lib.my;
{
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ alacritty ];
        activation.linkMutableAlacrittyConfig =
          link.createMutableLinkActivation {
            internalPath = ".config/alacritty";
            isDevMode = cfg.enableDevMode;
          };
      };

      xdg.configFile = mkIf (cfg.enableDevMode == false) {
        "alacritty".source = dotfiles.".config".alacritty.source;
      };
    };
}
