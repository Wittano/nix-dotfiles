{ config, lib, modulesPath, username ? "wittano", ... }: {
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
    # This mounting works only for KVM virtualization.
    # Before start VM, you have to add a Filesystem to your virutal machine.
    # I didn't test this configuration on other hypervisor like e.g. Virutalbox, so I don't know it's will be worked
    "/home/${username}/projects/config/nix-dotfiles" = {
      device = "/share";
      fsType = "9p";
    };
  };
}
