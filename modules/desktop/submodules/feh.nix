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
  autostart = [{
    name = "setup-wallpaper";
    path = [ rollWallpaper ];
    script = "rollWallpaper";
  }];

  config = {
    home-manager.users.wittano.home.packages = [ rollWallpaper ];
  };
}
