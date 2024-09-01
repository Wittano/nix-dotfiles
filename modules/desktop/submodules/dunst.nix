{ config, ... }:
{
  config = {
    home-manager.users.wittano.services.dunst = rec {
      enable = true;
      configFile = "${config.home-manager.users.wittano.xdg.configHome}/dunst/dunstrc.d/${catppuccin.prefix}-catppuccin.conf";
      catppuccin = {
        enable = true;
        flavor = config.catppuccin.flavor;
        prefix = "01";
      };
    };
  };
}
