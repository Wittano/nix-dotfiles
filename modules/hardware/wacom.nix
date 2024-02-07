{ config, pkgs, lib, home-manager, ... }:
with lib;
let
  cfg = config.modules.hardware.wacom;
  xsetwacom = "${pkgs.xf86_input_wacom}/bin/xsetwacom";
  awk = "${pkgs.gawk}/bin/awk";
  serviceScript = pkgs.writeShellScriptBin "setup-wacom" ''
    #!/bin/bash
    devices=$(${xsetwacom} list devices | ${awk} '{print $9}')

    for d in $devices; do
      ${xsetwacom} --set "$d" MapToOutput HEAD-0
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

      # TODO Fix non-starting service to map table to right display
      systemd.user.services."setup-wacom" = mkIf ((builtins.length config.services.xserver.xrandrHeads) > 1) {
        Unit.Description = "Map wacom tablet to main display";
        Service = {
          Environment = "DISPLAY=:0";
          Type = "simple";
          ExecStart = "${serviceScript}/bin/setup-wacom";
        };
        Install.WantedBy = [ "graphical.target" ];
      };

      programs.fish.functions.fixWacom.body =
        /*fish*/''
        set -l devices (${xsetwacom} list devices | ${awk} '{print $9}')

        for d in $devices;
          ${xsetwacom} --set "$d" MapToOutput HEAD-0
        end
      '';
    };
  };
}
