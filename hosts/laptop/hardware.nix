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
    "/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "btrfs";
    };
  };

  boot = {
    supportedFilesystems = [ "btrfs" ];
    loader = {
      grub.enableCryptodisk = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices = {
      crypthome = {
        device = "/dev/disk/by-label/HOME";
        preLVM = true;
      };
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
