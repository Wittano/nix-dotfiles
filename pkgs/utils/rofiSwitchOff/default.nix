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
      QTILE=$(${toybox}/bin/pgrep qtile)
      if [ -n "$QTILE" ]; then
        echo "Kill qtile $QTILE"
        kill -9 "$QTILE"
      fi 
      BSPWM=$(${toybox}/bin/pgrep bspwm)
      if [ -n "$BSPWM" ]; then
        kill -9 "$BSPWM"
      fi
      ;;
    "$REBOOT")
      ${systemd}/bin/reboot
      ;;
    "*")
      echo "invalid option"
      exit 1
      ;;
    esac
  '';
}
