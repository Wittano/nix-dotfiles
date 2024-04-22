{ pkgs, lib, dotfiles, ... }:
with lib;
with lib.my;
let
  rollWallpaper = pkgs.writeShellApplication {
    name = "rollWallpaper";
    runtimeInputs = with pkgs; [ feh ];
    text = "feh --bg-fill --randomize ${dotfiles.wallpapers.source} --bg-fill --randomize ${dotfiles.wallpapers.source}";
  };
in
{
  modules.desktop.qtile.autostartPrograms = [
    "${rollWallpaper}/bin/rollWallpaper"
  ];

  home-manager.users.wittano.home.packages = [ rollWallpaper ];
}
