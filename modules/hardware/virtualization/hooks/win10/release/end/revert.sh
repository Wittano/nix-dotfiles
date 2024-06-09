#!/usr/bin/env bash
set -x

# Disable VFIO
modprobe -r vfio_iommu_type1 vfio_pci vfio_virqfd

# Re-Bind GPU to Nvidia Driver
timeout 5s virsh nodedev-reattach pci_0000_01_00_0
timeout 5s virsh nodedev-reattach pci_0000_01_00_1

echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/bind

# Reload nvidia modules
modprobe drm
modprobe drm_kms_helper
modprobe i2c_nvidia_gpu
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_drm
modprobe nvidia_uvm

nvidia-xconfig --query-gpu-info >/dev/null 2>&1

# Restart Display Manager
systemctl start display-manager.service

# Rebind VT consoles
echo 1 >/sys/class/vtconsole/vtcon0/bind
echo 1 >/sys/class/vtconsole/vtcon1/bind
