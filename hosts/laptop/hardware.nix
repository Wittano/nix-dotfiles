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
    "/mnt/backup" = {
      device = "/dev/disk/by-label/BACKUP";
      fsType = "btrfs";
    };
  };

  boot = {
    loader = {
      grub.enableCryptodisk = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices = {
      cryptroot.device = "/dev/disk/by-uuid/fcEuNQ-0SCr-dfKI-9ppi-ZHIS-OUtP-gaWpMo";
      crypthdd.device = "/dev/disk/by-uuid/9M8Fd2-Dttq-mRyD-u0BC-hz3z-JYWM-jTEwlH";
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
