_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/fileSwap";
      size = 8192;
    }
    {
      device = "/dev/disk/by-label/SWAP";
    }
  ];
}
