{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  name = "setup-wacom";
  setupWacom = pkgs.writeShellApplication {
    inherit name;

    runtimeInputs = with pkgs;[ xf86_input_wacom gawk ];
    text = ''
      devices=$(xsetwacom list devices | awk '{print $9}')

      for d in $devices; do
        xsetwacom --set "$d" MapToOutput HDMI-A-0
        # Enable scrolling on middle(lower) button
        xsetwacom --set "$d" Button 2 "pan"
        xsetwacom --set "$d" PanScrollThreshold 150
        xsetwacom --set "$d" Rotate half
      done
    '';
  };
in
{
  options.services.xserver.wacom.wittano.enable = mkEnableOption "Enable support for wacom graphic tablet";

  config = mkIf config.services.xserver.wacom.wittano.enable {
    services.xserver.wacom.enable = true;

    services.udev = {
      enable = mkForce true;
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="056a", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="${name}.service"
      '';
    };

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
