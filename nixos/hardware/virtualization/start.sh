#!/usr/bin/env bash
# Helpful to read output when debugging
set -x

function _revert() {
    bash /var/lib/libvirt/hooks/qemu.d/win10/release/end/revert.sh
    exit 1
}

trap _revert ERR

# Stop display manager
systemctl stop display-manager.service

while systemctl is-active --quiet "display-manager.service"; do
    sleep 1
done

# Unbind VTconsoles
echo 0 >/sys/class/vtconsole/vtcon0/bind
echo 0 >/sys/class/vtconsole/vtcon1/bind

# modprobe -r nvidia_uvm
# modprobe -r nvidia_drm
# modprobe -r nvidia_modeset
# modprobe -r nvidia

modprobe -r amdgpu

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_07_00_0
virsh nodedev-detach pci_0000_07_00_1

modprobe vfio_iommu_type1
modprobe vfio_pci
