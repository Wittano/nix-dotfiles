#!/usr/bin/env bash

set -e

if [ ! $EUID -eq 0 ]; then
    echo "Script requires root premission"
    exit 1
fi

echo "Open encrypted disks"
HDD_ENCRYPTED_NAME="hdd"
if [ ! -b "/dev/mapper/$HDD_ENCRYPTED_NAME" ]; then
    cryptsetup -v luksOpen /dev/sda "$HDD_ENCRYPTED_NAME"
fi

SDD_ENCRYPTED_NAME="ssd"
if [ ! -b "/dev/mapper/$SDD_ENCRYPTED_NAME" ]; then
    cryptsetup -v luksOpen /dev/sdb2 "$SDD_ENCRYPTED_NAME"
fi

sleep 5s

echo "Mounting ROOT partition"
ROOT_DIR=/mnt
mount /dev/disk/by-label/ROOT "$ROOT_DIR"

echo "Create requires directories"
mkdir -p "$ROOT_DIR/boot/efi" "$ROOT_DIR/backup" "$ROOT_DIR/nix/store"

echo "Mount BOOT, BACKUP and NIX_STORE partitions"
mount /dev/disk/by-label/BOOT "$ROOT_DIR/boot/efi"
mount /dev/disk/by-label/BACKUP "$ROOT_DIR/backup"
mount /dev/disk/by-label/NIX_STORE "$ROOT_DIR/nix/store"

echo "Install NixOS"
nixos-install --flake .#laptop --root "$ROOT_DIR" && umount -R "$ROOT_DIR"
