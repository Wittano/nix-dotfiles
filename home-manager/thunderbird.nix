{ config, lib, pkgs, ... }:
with lib;
let
  serviceName = "thunderbird-headless";

  thunderbird = pkgs.thunderbird.overrideAttrs (attrs: {
    desktopItem = attrs.desktopItem.override (old: {
      exec = pkgs.writeShellScript "thunderbird-wrapper" ''
        ${pkgs.systemd}/bin/systemctl --user stop ${serviceName}
        ${old.exec}
      '';
    });
  });
in
{
  options.programs.thunderbird.wittano.enable = mkEnableOption "thunderbird";
  config = mkIf config.programs.thunderbird.wittano.enable {
    home.packages = [ thunderbird ];

    systemd.user = rec {
      services.${serviceName} = {
        Unit = {
          Description = "Thunderbird in headless mode";
          After = [ "network.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${thunderbird}/bin/thunderbird --headless";
          ExecCondition = "${pkgs.bash}/bin/bash -c '! ${pkgs.toybox}/bin/pgrep thunderbird'";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
      timers.${serviceName} = {
        inherit (services.${serviceName}) Unit;

        Timer.OnCalendar = "*-*-* *:*:00";
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };

  };
}
