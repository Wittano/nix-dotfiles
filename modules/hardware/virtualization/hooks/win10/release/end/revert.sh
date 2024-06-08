#!/usr/bin/env bash
set -x

# Disable VFIO
modprobe -r vfio_iommu_type1 vfio_pci vfio_virqfd

# Re-Bind GPU to Nvidia Driver
timeout 5s virsh nodedev-reattach pci_0000_01_00_0
timeout 5s virsh nodedev-reattach pci_0000_01_00_1

# Reload nvidia modules
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm

# Rebind VT consoles
echo 1 >/sys/class/vtconsole/vtcon0/bind

nvidia-xconfig --query-gpu-info >/dev/null 2>&1

echo "efi-framebuffer.0" >/sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Display Manager
systemctl start display-manager.service
