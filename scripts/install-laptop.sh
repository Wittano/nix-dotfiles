#!/usr/bin/env bash

set -e

if [ ! $EUID -eq 0 ]; then
    echo "Script requires root premission"
    exit 1
fi

cryptsetup -v luksOpen /dev/sda hdd
cryptsetup -v luksOpen /dev/sdb2 ssd

mount /dev/disk/by-label/ROOT /mnt

mkdir -p /mnt/boot/efi /mnt/backup /mnt/nix/store

mount /dev/disk/by-label/BOOT /mnt/boot/efi
mount /dev/disk/by-label/BACKUP /mnt/backup
mount /dev/disk/by-label/NIX_STORE /mnt/nix/store

sudo nixos-install --flake .#laptop && umount -R /mnt
