#!/usr/bin/env bash

vm=""
if [[ -z "$vm" ]]; then
    logger -s "missing vm"
    exit 1
fi

for f in /tmp/*.xml; do
    device_file=$(echo "$f" | cut -f 3 -d '/' | cut -f 1 -d '.')
    idProduct=$(echo "$device_file" | cut -f 1 -d '-')
    vendorId=$(echo "$device_file" | cut -f 2 -d '-')

    device="$vendorId:$idProduct"
    if ! lsusb | cut -f 6 -d ' ' | grep -q "$device"; then
        virsh detach-device "$vm" --live --file "$f" || logger -s "failed detach-device $device on $vm" 
    else 
        logger "device $vendorId:$idProduct is conneceted"
    fi
done
