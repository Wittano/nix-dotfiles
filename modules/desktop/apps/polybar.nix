{ pkgs, lib, home-manager, dotfiles, config, name, ... }:
with lib;
with lib.my;
{
  fonts.packages = with pkgs; [ font-awesome font-awesome_5 siji ];

  # TODO Migate to home-manager options
  home-manager.users.wittano.home.packages = with pkgs; [ polybar ];

  modules.desktop.${name}.mutableSources = {
    ".config/polybar" = dotfiles.polybar.source;
  };

}

