{ pkgs, lib, home-manager, dotfiles, cfg, ... }:
with lib;
with lib.my; {
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ nitrogen ];
      activation.linkMutableNitrogen =
        link.createMutableLinkActivation cfg ".config/nitrogen";
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      "nitrogen/bg-saved.cfg".text = ''
        [xin_1]
        file=${dotfiles.wallpapers."11.jpeg".source}
        mode=0
        bgcolor=#000000

        [xin_0]
        file=${dotfiles.wallpapers."33.png".source}
        mode=0
        bgcolor=#000000
      '';
      "nitrogen/nitrogen.cfg".text = ''
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
        dirs=${dotfiles.wallpapers.source};
      '';
    };
  };
}
