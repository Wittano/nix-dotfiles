{ pkgs, lib, dotfiles, ... }:
with lib;
with lib.my;
{
  modules.desktop.qtile.autostartPrograms = [ "nitrogen --restore" ];

  home-manager.users.wittano = {
    home.packages = with pkgs; [ nitrogen ];

    xdg.configFile = {
      "nitrogen/bg-saved.cfg".source = mapper.toCfg "bg-saved.cfg"
        {
          xin_1 = {
            file = dotfiles.wallpapers."23.jpeg".source;
            mode = 0;
            bgcolor = " #000000";
          };
          xin_0 = {
            file = dotfiles.wallpapers."50.jpg".source;
            mode = 0;
            bgcolor = "#000000";
          };
        };
      "nitrogen/nitrogen.cfg".source = mapper.toCfg "nitrogen.cfg" {
        geometry = {
          posx = 286;
          posy = 112;
          sizex = 1172;
          sizey = 818;
        };
        nitrogen = {
          view = "icon";
          recurse = true;
          sort = "alpha";
          icon_caps = "false";
          dirs = dotfiles.wallpapers.source;
        };
      };
    };
  };
}
