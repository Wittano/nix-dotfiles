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
        device = "/dev/disk/by-uuid/ed7bc4f8-930d-44b6-b0fb-46056454cc5e";
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
