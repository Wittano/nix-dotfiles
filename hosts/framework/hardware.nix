_: {
  fileSystems = {
    "/" = {
      device = "/dev/nixos/root";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/home" = {
      device = "/dev/nixos/root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
    "/nix" = {
      device = "/dev/nixos/root";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/var/log" = {
      device = "/dev/nixos/root";
      fsType = "btrfs";
      options = [ "subvol=logs" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [{
    device = "/dev/nixos/swap";
  }];

  boot = {
    initrd.luks.devices.cryptroot.device = "/dev/disk/by-uuid/UUID-OF-SDA2";
    supportedFilesystems = [ "btrfs" ];
  };
}
