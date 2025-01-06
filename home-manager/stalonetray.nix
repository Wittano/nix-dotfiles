{ config, lib, pkgs, ... }:
with lib;
{
  options.services.stalonetray.wittano.enable = mkEnableOption "Custom stalonetray configuration";

  config = mkIf config.services.stalonetray.wittano.enable {
    systemd.user.targets.tray.Unit = rec {
      Description = "System tray target";
      Requires = [ "graphical-session.target" ];
      After = Requires;
    };

    desktop.autostart.programs = [
      "${pkgs.toybox}/bin/sleep 5 && ${pkgs.systemd}/bin/systemctl --user restart stalonetray.service"
    ];

    services.stalonetray = {
      enable = true;
      config = {
        background = "#24273a";
        icon_size = 28;
        geometry = "1x1+900+19";
      };
    };
  };
}
