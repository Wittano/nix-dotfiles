{ pkgs, lib, home-manager, dotfiles, cfg, ... }:
with lib;
with builtins;
{
  fonts.packages = with pkgs; [ font-awesome font-awesome_5 siji ];

  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ polybar ];
      activation.linkMutablePolybarConfig = link.createMutableLinkActivation cfg ".config/polybar";
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      polybar.source = dotfiles.config.polybar.source;
    };
  };

}

