#!/usr/bin/env bash
# Helpful to read output when debugging
set -x

system=$(grep -e '^ID' /etc/os-release | cut -f 2 -d '=')

function _revert() {
  if [ "$system" == "nixos" ]; then
    bash /var/libvirt/hooks/qemu.d/win10/release/end/revert.sh
  else
    bash /etc/libvirt/hooks/qemu.d/win10/release/end/revert.sh
  fi
  exit 0
}

trap _revert ERR

# Stop display manager
systemctl stop display-manager.service

if pgrep -x "gdm" >/dev/null; then
  killall gdm-x-session
fi

# Boinc
if [ "$(pgrep -c boinc)" -gt 0 ]; then
  # Fix for NixOS version of BOINC
  systemctl stop "boinc*"
fi

# Vbox
if [ -f /usr/lib/systemd/system/vboxdrv.service ]; then
  systemctl stop vboxdrv.service
fi

# Unbind VTconsoles
echo 0 >/sys/class/vtconsole/vtcon0/bind

# Unbind EFI-Framebuffer
if ! grep -q --ignore-case fedora /etc/os-release; then
    echo efi-framebuffer.0 >/sys/bus/platform/drivers/efi-framebuffer/unbind
fi

timeout 10s modprobe -r nvidia_uvm nvidia_drm nvidia_modeset nvidia

# Avoid a Race condition by waiting 2 seconds. This can be calibrated to be shorter or longer if required for your system
sleep 2

# Unbind the GPU from display driver
virsh nodedev-detach pci_0000_01_00_0
virsh nodedev-detach pci_0000_01_00_1

modprobe vfio_iommu_type1
modprobe vfio_pci
modprobe vfio_virqfd

if [ "$system" != "debian" ]; then
  modprobe vfio_pci_core
fi
