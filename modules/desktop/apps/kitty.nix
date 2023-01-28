{ pkgs, home-manager, lib, dotfiles, cfg, ... }:
with lib;
with lib.my;
{
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ kitty ];
        activation.linkMutableKittyConfig =
          link.createMutableLinkActivation {
            internalPath = ".config/kitty";
            isDevMode = cfg.enableDevMode;
          };
      };

      # TODO Add kitty themes https://github.com/dexpota/kitty-themes
      xdg.configFile = mkIf (cfg.enableDevMode == false) {
        "kitty".source = dotfiles.".config".kitty.source;
      };
    };
}
