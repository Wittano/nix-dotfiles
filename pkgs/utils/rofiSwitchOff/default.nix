{ toybox
, systemd
, rofi
, writeShellApplication
}: writeShellApplication {
  name = "switch-off";
  runtimeInputs = [ rofi toybox ];
  text = ''
    SHUTDOWN="Shutdown"
    LOGOUT="Logout"
    REBOOT="Reboot"

    CHOICE=$(printf "%s\n%s\n%s" $SHUTDOWN $LOGOUT $REBOOT | rofi -dmenu)

    case $CHOICE in
    "$SHUTDOWN")
      ${systemd}/bin/poweroff
      ;;
    "$LOGOUT")
      QTILE=$(pgrep qtile)
      BSPWM=$(pgrep bspwm)
      kill -9 "$QTILE"
      kill -9 "$BSPWM"
      ;;
    "$REBOOT")
      ${systemd}/bin/reboot
      ;;
    "*")
      exit 1
      ;;
    esac
  '';
}
