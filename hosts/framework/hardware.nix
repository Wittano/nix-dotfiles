_: {
  fileSystems = {
    "/" = {
      device = "/dev/nixos/root";
      fsType = "btrfs";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/dev/nixos/swap";
    size = 8 * 1024; # 16 GiB
  }];
}
