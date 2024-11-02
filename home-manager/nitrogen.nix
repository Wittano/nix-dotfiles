{ config, pkgs, lib, ... }:
with lib;
with lib.my;
{
  options.programs.nitrogen.wittano.enable = mkEnableOption "Enable custom kitty config";

  config = mkIf config.programs.nitrogen.wittano.enable {
    desktop.autostart.programs = [ "nitrogen --restore" ];

    home.packages = with pkgs; [ nitrogen ];

    xdg.configFile = {
      "nitrogen/bg-saved.cfg".source = mapper.toCfg "bg-saved.cfg"
        {
          xin_1 = {
            file = ./wallpapers/23.jpeg;
            mode = 0;
            bgcolor = " #000000";
          };
          xin_0 = {
            file = ./wallpapers/50.jpg;
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
          dirs = ./../wallpapers;
        };
      };
    };
  };
}
