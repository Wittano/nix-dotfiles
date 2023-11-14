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
        };
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      "nitrogen/bg-saved.cfg".source = builtins.toFile "bg-save.cfg" ''
        [xin_1]
        file=${dotfiles.Pictures.Wallpapers."asdfasdfa.jpeg".source}
        mode=0
        bgcolor=#000000

        [xin_0]
        file=${dotfiles.Pictures.Wallpapers."scenery.png".source}
        mode=0
        bgcolor=#000000
      '';
      "nitrogen/nitrogen.cfg".source = builtins.toFile "nitrogen.cfg" ''
        [geometry]
        posx=286
        posy=112
        sizex=1172
        sizey=818

        [nitrogen]
        view=icon
        recurse=true
        sort=alpha
        icon_caps=false
        dirs=${dotfiles.Pictures.Wallpapers.source};
      '';
    };
  };
}
