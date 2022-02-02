{ config, pkgs, ... }: {
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      efiSupport = true;
      enable = true;
      version = 2;
      device = "nodev";
    };
  };
}
