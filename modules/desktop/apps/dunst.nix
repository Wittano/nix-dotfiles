{ pkgs, home-manager, lib, dotfiles, cfg, ... }:
with lib;
with lib.my;
let
  catppuccinDunstConfig = mapper.mapDirToAttrs (pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "dunst";
    rev = "b0b838d38f134136322ad3df2b6dc57c4ca118cf";
    sha256 = "sha256-ruFcHh1dkd4Zy9qNlAA8qAksTzNjXPd2hSSmhdGgflU=";
  });
in
{
  home-manager.users.wittano.services.dunst = {
    enable = true;
    configFile = catppuccinDunstConfig.src."macchiato.conf".source;
  };
}
