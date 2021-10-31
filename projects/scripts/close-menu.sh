#!/bin/bash

NB='#212337'
SB='#4782FF'
OPTION=$(printf "Close\nLogout\nReboot" | dmenu -p "Close system" -l 3 -i -nb $NB -sb $SB)

function get_password(){
    HIDDEN_COLOR="#212337"
    echo | dmenu -p "Password:" -nb $HIDDEN_COLOR -nf $HIDDEN_COLOR -sb $HIDDEN_COLOR
}

function invalid_password(){
    echo "Invalid password" | dmenu -nb $NB -sb $SB
}

case $OPTION in
    "Close")
        get_password | sudo -S poweroff || invalid_password
        ;;
    "Logout")
        bspc quit
        ;;
    "Reboot")
        get_password | sudo -S reboot || invalid_password
esac
