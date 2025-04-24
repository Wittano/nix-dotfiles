_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/nix/store" = {
      device = "/dev/disk/by-label/NIX_STORE";
      fsType = "ext4";
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
