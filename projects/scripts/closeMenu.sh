#!/bin/bash

OPTION=$(printf "Close\nLogout\nReboot" | dmenu -p "Close system" -l 3 -i)

function get_password(){
    HIDDEN_COLOR="#212337"
    echo | dmenu -p "Password:" -nb $HIDDEN_COLOR -nf $HIDDEN_COLOR -sb $HIDDEN_COLOR
}

case $OPTION in
    "Close")
        get_password | sudo -S poweroff
        ;;
    "Logout")
        bspc quit
        ;;
    "Reboot")
        get_password | sudo -S reboot
esac
