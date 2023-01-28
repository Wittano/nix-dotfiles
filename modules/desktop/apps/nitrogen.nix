{ pkgs, lib, home-manager, dotfiles, cfg, ... }:
with lib;
with lib.my;
{
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ nitrogen ];

      activation =
        let
          customeActivation = path:
            link.createMutableLinkActivation {
              internalPath = path;
              isDevMode = cfg.enableDevMode;
            };
        in
        {
          linkMutableNitrogen = customeActivation ".config/nitrogen";
          linkMutableWallapapers = customeActivation "Pictures/Wallpapers";
        };
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      nitrogen.source = dotfiles.".config".nitrogen.source;
    };
  };
}
