{ config, pkgs, lib, ... }:
with lib;
let
  rollWallpaper = pkgs.writeShellApplication {
    name = "rollWallpaper";
    runtimeInputs = with pkgs; [ feh ];
    text = "feh --bg-fill --randomize ${./wallpapers} --bg-fill --randomize ${./wallpapers}";
  };
in
{
  options.programs.feh.wittano.enable = mkEnableOption "Enable custom feh config";

  config = mkIf config.programs.feh.wittano.enable {
    programs.feh.enable = true;

    desktop.autostart.programs = [ (meta.getExe rollWallpaper) ];

    home.packages = [ rollWallpaper ];
  };
}
