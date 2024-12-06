#!/usr/bin/env bash

vm=""
if [[ -z "$vm" ]]; then
    logger -s "missing vm name"
    exit 1
fi

vm_state=$(virsh list --state-running | tail -n +3 | grep "$vm")
if [[ -z "$vm_state" ]]; then
    logger "win10-work vm isn't running"  
    exit 0
fi

if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    logger -s "missing idVendor or idProduct"
    exit 1
fi

device="$2:$1"
devices=$(lsusb | grep "$device")
if [[ -n "$devices" ]]; then
    path="/tmp/$1-$2.xml"
    if [[ ! -f "$path" ]]; then
        cat >"$path" <<EOL 
        <hostdev mode='subsystem' type='usb' managed='yes'>
            <source>
                <vendor id="0x$2"/>
                <product id="0x$1"/>
            </source>
        </hostdev>
EOL
    fi

    virsh attach-device "$vm" --live --file "$path"
else
    logger "$vm not running"
fi
