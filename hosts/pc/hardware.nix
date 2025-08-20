_: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-label/NIX_HOME";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-label/NIX_STORE";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };
}
