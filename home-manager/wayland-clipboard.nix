{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.services.wayland-clipboard.enable = mkEnableOption "utilites to enable clipboard on any Wayland compositor";

  config = mkIf config.services.wayland-clipboard.enable {
    services.cliphist.enable = true;

    home.packages = [ pkgs.wl-clipboard ];

    desktop.autostart.programs = [
      "wl-paste --watch cliphist store &"
    ];
  };
}
