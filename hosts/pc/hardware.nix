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
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/mnt/backup" = {
      device = "/dev/disk/by-uuid/f031287c-48e3-479e-8958-1986a02d0a8f";
      fsType = "ext4";
    };
  };
}
