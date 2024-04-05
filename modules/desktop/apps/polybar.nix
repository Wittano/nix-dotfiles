{ pkgs, lib, home-manager, dotfiles, cfg, ... }:
with lib;
with lib.my;
{
  fonts.packages = with pkgs; [ font-awesome font-awesome_5 siji ];

  home-manager.users.wittano = {
    home.packages = with pkgs; [ polybar ];

    xdg.configFile.polybar.source = dotfiles.polybar.source;
  };

}

