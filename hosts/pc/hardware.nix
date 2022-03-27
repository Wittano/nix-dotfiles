{ ... }: {
  services.xserver.xrandrHeads = [
    "HDMI-0"
    {
      output = "DIV-D-0";
      primary = true;
    }
  ];

  fileSystems = {
    "/" = {
      device = "/dev/nixos/root";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/nixos/home";
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
