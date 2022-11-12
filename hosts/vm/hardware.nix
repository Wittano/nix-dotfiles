{ config, lib, modulesPath, ... }: {
  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  boot = {
    initrd.availableKernelModules = [ "virtio_pci" "virtio_blk" ];
    loader.systemd-boot.enable = true;
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };
}
