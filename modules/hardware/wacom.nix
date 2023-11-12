{ config, pkgs, lib, home-manager, ... }:
with lib;
let
  cfg = config.modules.hardware.wacom;

  wacomScript = pkgs.writeScript "wacom-multi-monitor.sh" ''
    tablet=`${pkgs.xf86_input_wacom}/bin/xsetwacom list devices | ${pkgs.gawk}/bin/awk '{print $9}'`

    for i in $tablet; do
        ${pkgs.xf86_input_wacom}/bin/xsetwacom --set "$i" MapToOutput HEAD-0
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
    services.xserver.wacom.enable = cfg.enable;

    home-manager.users.wittano.programs = {
      fish = mkIf config.modules.shell.fish.enable {
        shellAbbrs = { wacom = "bash ${wacomScript}"; };
      };
    };
  };
}
