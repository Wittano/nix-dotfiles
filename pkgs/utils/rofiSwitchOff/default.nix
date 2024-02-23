{ toybox
, systemd
, rofi
, writeScriptBin
}: writeScriptBin "switch-off" /*bash*/ ''
  #!/usr/bin/env bash

  SHUTDOWN="Shutdown"
  LOGOUT="Logout"
  REBOOT="Reboot"

  CHOICE=$(${toybox}/bin/printf "%s\n%s\n%s" $SHUTDOWN $LOGOUT $REBOOT | ${rofi}/bin/rofi -dmenu)

  case $CHOICE in
  "$SHUTDOWN")
    ${systemd}/bin/poweroff
    ;;
  "$LOGOUT")
    QTILE=$(${toybox}/bin/pgrep qtile)
    BSPWM=$(${toybox}/bin/pgrep bspwm)
    ${toybox}/bin/kill -9 "$QTILE"
    ${toybox}/bin/kill -9 "$BSPWM"
    ;;
  "$REBOOT")
    ${systemd}/bin/reboot
    ;;
  "*")
    exit 1
    ;;
  esac
''
