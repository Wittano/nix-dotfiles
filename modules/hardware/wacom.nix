{ config, pkgs, lib, home-manager, ... }:
with lib;
let
  cfg = config.modules.hardware.wacom;
  dependecies = strings.makeBinPath (with pkgs;[ xf86_input_wacom gawk ]);
  serviceScript = pkgs.writeScript "setup-wacom.sh" /*fish*/''
    #!/bin/bash
    devices=$(xsetwacom list devices | awk '{print $9}')

    for d in $devices; do
      xsetwacom --set "$d" MapToOutput HEAD-0
    done
  '';
in
{
  options = {
    modules.hardware.wacom = {
      enable = mkEnableOption "Enable support for wacom graphic tablet";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.wacom.enable = true;

    home-manager.users.wittano = {
      home.packages = with pkgs; [ krita ];

      systemd.user.services."setup-wacom" = {
        Unit = {
          Description = "Map tablet to primary display";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash ${serviceScript}";
          Environment = [ ''DISPLAY=":0"'' "PATH=${dependecies}" ];
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      programs.fish.functions.fixWacom.body = /*fish*/ ''
        set -l devices (${pkgs.xf86_input_wacom}/bin/xsetwacom list devices | ${pkgs.gawk}/bin/awk '{print $9}')

        for d in $devices;
          ${pkgs.xf86_input_wacom}/bin/xsetwacom --set "$d" MapToOutput HEAD-0
        end
      '';
    };
  };
}
