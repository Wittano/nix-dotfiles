#!/bin/bash
set -eo pipefail

_error_msg() {
    echo "$1"
    exit 1
}

_destroy_vm() {
    vagrant destroy -f
}

if [ -z "$1" ] || [ -z "$2" ]; then
    _error_msg 'Invalid arguments: vm <vm_name> <vagrant_option>'
fi

if [ -z "$(command -v vagrant)" ]; then
    _error_msg 'Vagrant not found!'
fi

vms_dir=$HOME/projects/config/system/vms
vms=$(ls "$vms_dir")

if [ "$1" == "all" ]; then
    for dir in $vms; do
        echo "$dir - virutal machine"
        cd "$vms_dir/$dir"

        if [ "$2" != "destroy" ]; then
            vagrant "$2" -f
        else
            vagrant "$2"
        fi
    done

    exit 0
fi

for dir in $vms; do
    if [ "$dir" == "$1" ]; then
        vm_dir=$vms_dir/$dir

        cd "$vm_dir"

        mkdir -p "$vm_dir"/data

        case $2 in
        'rebuild')
            _destroy_vm
            vagrant up
            ;;
        'start')
            vagrant up
            vagrant ssh
            ;;
        *)
            vagrant "$2"
            ;;
        esac
    fi
done
