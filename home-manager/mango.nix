{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  systemdTarget = "mango-session.target";
in
{
  imports = [
    inputs.mangowm.hmModules.mango
  ];

  options.wayland.windowManager.mango.wittano.enable =
    mkEnableOption "mango - tiling Wayland compositor";

  config = mkIf config.wayland.windowManager.mango.wittano.enable {
    desktop.autostart.programs = config.wayland.windowManager.mango.systemd.extraCommands;

    wayland.windowManager.mango = {
      enable = true;
      package = pkgs.mangowc;
      systemd.enable = true;
    };

    services.wlsunset.wittano.systemdTarget = systemdTarget;
    programs.waybar.wittano.systemdTarget = systemdTarget;
  };
}
