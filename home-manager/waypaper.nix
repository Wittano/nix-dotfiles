{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options.programs.waypaper.enable = mkEnableOption "waypaper - wallpaper engin for Wayland sessions";

  config = mkIf config.programs.waypaper.enable {
    home.packages = with pkgs; [
      swaybg
      waypaper
    ];

    desktop.autostart.programs = [
      "waypaper --restore"
    ];
  };
}
