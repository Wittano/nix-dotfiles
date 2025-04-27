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
    supportedFilesystems = [ "btrfs" ];
    loader = {
      grub.enableCryptodisk = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-uuid/4cb5d676-9a9d-4cdc-84b6-0156f0ae6a9c";
        preLVM = true;
        bypassWorkqueues = true;
      };
      crypthdd = {
        device = "/dev/disk/by-uuid/492227ea-4ab0-4dee-9cea-cf9d89e5bb6f";
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
