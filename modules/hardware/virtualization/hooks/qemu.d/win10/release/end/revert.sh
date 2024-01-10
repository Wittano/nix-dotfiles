#!/usr/bin/env bash
set -x

system=$(grep -e '^ID' /etc/os-release | cut -f 2 -d '=')

if grep -q --ignore-case fedora /etc/os-release; then
  reboot
fi

# Disable VFIO
if grep -q --ignore-case fedora /etc/os-release; then
  modprobe -r vfio_iommu_type1 vfio_pci vfio_virqfd vfio_pci_core
else
  modprobe -r vfio_iommu_type1 vfio_pci vfio_virqfd
fi
# Re-Bind GPU to Nvidia Driver
timeout 5s virsh nodedev-reattach pci_0000_01_00_0
timeout 5s virsh nodedev-reattach pci_0000_01_00_1

if [ "$system" != "debian" ]; then
  nvidia-smi -pm 0
fi

# Reload nvidia modules
modprobe nvidia
modprobe nvidia_modeset
modprobe nvidia_uvm
modprobe nvidia_drm

# Boinc
if [ -f /etc/systemd/system/boinc.service ] || [ -f /usr/lib/systemd/system/boinc-client.service ]; then
  # Fix for NixOS version of BOINC
  systemctl start "boinc*" || echo "Failed to launch BOINC"
fi

# Vbox
if [ -f /usr/lib/systemd/system/vboxdrv.service ]; then
  systemctl start vboxdrv.service || echo "Failed to launch virtualbox kernel modules or daemon"
fi

# Rebind VT consoles
echo 1 >/sys/class/vtconsole/vtcon0/bind

nvidia-xconfig --query-gpu-info >/dev/null 2>&1

echo "efi-framebuffer.0" >/sys/bus/platform/drivers/efi-framebuffer/bind

# Restart Display Manager
systemctl start display-manager.service
