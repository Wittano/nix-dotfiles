_: {
  fileSystems = {
    "/" = {
      device = "/dev/nixos/ROOT";
      fsType = "btrfs";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };
}
