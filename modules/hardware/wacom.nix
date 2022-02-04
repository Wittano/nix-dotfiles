{ config, pkgs, lib, home-manager, ... }:
with lib;
with builtins;
let
  cfg = config.modules.hardware.wacom;

  wacomScript = toFile "wacom-multi-monitor.sh" ''
    #!/usr/share/env bash

    if [ -z `which xsetwacom` ]; then
        echo "Wacom driver isn't installed!"
        exit -1;
    fi

    tablet=`xsetwacom list devices | awk '{print $9}'`

    for i in $tablet; do
        xsetwacom --set "$i" MapToOutput HEAD-0
    done
  '';
in {
  options = {
    modules.hardware.wacom = {
      enable = mkEnableOption "Enable support for wacom graphic tablet";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.wacom.enable = cfg.enable;

    home-manager.users.wittano.programs = {
      fish = mkIf config.modules.shell.fish.enable {
        shellAbbrs = { wacom = "bash ${wacomScript}"; };
      };
    };
  };
}
