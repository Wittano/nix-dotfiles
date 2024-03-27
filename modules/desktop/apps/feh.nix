{ config, pkgs, lib, home-manager, dotfiles, cfg, ... }:
with lib;
with lib.my;
let
  rollWallpaper = "${pkgs.feh}/bin/feh --bg-fill --randomize ${dotfiles.wallpapers.source} --bg-fill --randomize ${dotfiles.wallpapers.source}";
in
{
  modules.desktop.qtile.autostartPrograms = [
    rollWallpaper
  ];

  home-manager.users.wittano.programs.fish.shellAliases.rollWallpaper = rollWallpaper;
}
