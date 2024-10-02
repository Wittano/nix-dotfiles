{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.wacom;
  name = "setup-wacom";
  setupWacom = pkgs.writeShellApplication {
    inherit name;

    runtimeInputs = with pkgs;[ xf86_input_wacom gawk ];
    text = ''
      devices=$(xsetwacom list devices | awk '{print $9}')

      for d in $devices; do
        xsetwacom --set "$d" MapToOutput HEAD-0
        # Enable scrolling on middle(lower) button
        xsetwacom --set "$d" Button 2 "button +2 pan"
        xsetwacom --set "$d" PanScrollThreshold 150
      done
    '';
  };
in
{
  options = {
    modules.hardware.wacom = {
      enable = mkEnableOption "Enable support for wacom graphic tablet";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.wacom.enable = true;

    # Development fixs and features for drivers
    modules.dev.lang.ides = [ "cpp" ];

    services.udev = {
      enable = mkForce true;
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="056a", TAG+="systemd", ENV{SYSTEMD_USER_WANTS}+="${name}.service"
      '';
    };

    home-manager.users.wittano = {
      home.packages = with pkgs; [ krita setupWacom ];

      systemd.user.services.${name} = {
        Unit = {
          Description = "Map tablet to primary display";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = meta.getExe setupWacom;
          Environment = [ ''DISPLAY=":0"'' ];
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
