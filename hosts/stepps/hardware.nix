_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_ROOT";
      fsType = "ext4";
      options = ["noatime"];
      neededForBoot = true;
    };
    "/home" = {
      device = "/dev/disk/by-label/NIXOS_HOME";
      options = ["noatime"];
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      neededForBoot = true;
    };
    "/mnt/gaming" = {
      device = "/dev/disk/by-label/GAMING";
      fsType = "ext4";
      options = ["noatime"]; 
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-label/SWAP";
    }
  ];
}
