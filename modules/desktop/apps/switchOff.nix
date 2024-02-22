{ pkgs, lib, config, ... }:
# TODO Migarte to pkgs directory
let
  kill = "${pkgs.toybox}/bin/kill";
  pgrep = "${pkgs.toybox}/bin/pgrep";
  program = pkgs.writeScriptBin "switch-off" /*bash*/
    ''
      #!/usr/bin/env bash

      SHUTDOWN="Shutdown"
      LOGOUT="Logout"
      REBOOT="Reboot"

      CHOICE=$(${pkgs.toybox}/bin/printf "%s\n%s\n%s" $SHUTDOWN $LOGOUT $REBOOT | ${pkgs.rofi}/bin/rofi -dmenu)

      case $CHOICE in
      "$SHUTDOWN")
        ${pkgs.systemd}/bin/poweroff
        ;;
      "$LOGOUT")
        QTILE=$(${pgrep} qtile)
        BSPWM=$(${pgrep} bspwm)
        ${kill} -9 "$QTILE"
        ${kill} -9 "$BSPWM"
        ;;
      "$REBOOT")
        ${pkgs.systemd}/bin/reboot
        ;;
      "*")
        exit 1
        ;;
      esac
    '';
in
{ home-manager.users.wittano.home.packages = [ program ]; }

