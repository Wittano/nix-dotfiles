{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.services.xserver.wacom.wittano;

  name = "setup-wacom";
  setupWacom = pkgs.writeShellApplication {
    inherit name;

    runtimeInputs = with pkgs;[ xf86_input_wacom gawk ];
    text = ''
      if [ "$DISPLAY" == "" ]; then
        export DISPLAY=':0'
      fi

      devices=$(xsetwacom list devices | awk '{print $9}')

      for d in $devices; do
        xsetwacom --set "$d" MapToOutput ${cfg.monitor}
        # Enable scrolling on middle(lower) button
        xsetwacom --set "$d" Button 2 "pan"
        xsetwacom --set "$d" PanScrollThreshold 150
        xsetwacom --set "$d" Rotate half
      done
    '';
  };

  primaryMonitor = lists.findFirst
    (x: x.primary)
    { output = "HDMI-A-0"; }
    config.services.xserver.xrandrHeads;
in
{
  options.services.xserver.wacom.wittano = {
    enable = mkEnableOption "Enable support for wacom graphic tablet";
    monitor = mkOption {
      type = types.str;
      description = "Select monitor which wacom tablet will be mapped";
      example = "HDMI-A-0";
      default = primaryMonitor.output;
    };
  };

  config = mkIf config.services.xserver.wacom.wittano.enable {
    services.xserver.wacom.enable = true;

    environment.systemPackages = [ setupWacom ];

    systemd.user.services.${name} = {
      description = "Map tablet to primary display";
      after = [ "graphical-session-pre.target" ];
      partOf = [ "graphical-session.target" ];

      environment = {
        DISPLAY = ":0";
      };
      script = meta.getExe setupWacom;

      wantedBy = [ "graphical-session.target" ];
    };
  };
}
