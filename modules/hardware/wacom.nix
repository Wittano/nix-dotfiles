{ config, pkgs, lib, home-manager, ... }:
with lib;
let
  cfg = config.modules.hardware.wacom;
in
{
  options = {
    modules.hardware.wacom = {
      enable = mkEnableOption "Enable support for wacom graphic tablet";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.wacom.enable = cfg.enable;

    home-manager.users.wittano = {
      home.packages = with pkgs; [ krita ];
      programs.fish.functions.fixWacom.body =
        let
          xsetwacom = "${pkgs.xf86_input_wacom}/bin/xsetwacom";
          awk = "${pkgs.gawk}/bin/awk";
        in
          /*fish*/''
          set -l devices (${xsetwacom} list devices | ${awk} '{print $9}')

          for d in $devices;
            ${xsetwacom} --set "$d" MapToOutput HEAD-0
          end
        '';
    };
  };
}
