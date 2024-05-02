{ pkgs, lib, dotfiles, ... }:
with lib;
with lib.my;
{
  mutableSources = {
    ".config/polybar" = dotfiles.polybar.source;
  };

  config = {
    fonts.packages = with pkgs; [ font-awesome font-awesome_5 siji nerdfonts ];

    # TODO Migate to home-manager options
    home-manager.users.wittano.home.packages = with pkgs; [ polybar ];
  };
}

