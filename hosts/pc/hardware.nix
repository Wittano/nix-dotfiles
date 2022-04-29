{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/pc/nixos";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/pc/home";
      fsType = "xfs";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/mnt/backup" = {
      device = "/dev/disk/by-label/BACKUP";
      fsType = "ext4";
    };
  };
}
