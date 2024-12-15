#!/usr/bin/env bash
set -x

function _reboot() {
    reboot || systemctl reboot
}

# Reboot system cause "throw kernel panic". I think it's casues by nvidia proprietary driver
# _reboot && exit 0

trap _reboot SIGINT SIGABRT SIGTERM ERR

# Disable VFIO
modprobe -r vfio_pci

# Re-Bind GPU to AMD Driver
timeout 5s virsh nodedev-reattach pci_0000_07_00_0
timeout 5s virsh nodedev-reattach pci_0000_07_00_1

# Reload nvidia modules
# modprobe nvidia
# modprobe nvidia_modeset
# modprobe nvidia_drm
# modprobe nvidia_uvm
modprobe amdgpu

# Rebind VT consoles
echo 1 >/sys/class/vtconsole/vtcon0/bind || _reboot
echo 1 >/sys/class/vtconsole/vtcon1/bind || _reboot

# Restart Display Manager
systemctl start display-manager.service
