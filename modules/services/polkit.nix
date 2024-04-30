{ pkgs, lib, config, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.services.polkit;
in
{
  options = {
    modules.services.polkit = {
      enable = mkEnableOption "Enable polkit authentication manager";
    };
  };

  config = mkIf (cfg.enable) {
    security.polkit.enable = true;

    # FIXME missing popup with authencation via polkit
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}

