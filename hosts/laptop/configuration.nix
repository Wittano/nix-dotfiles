{ ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  # TODO Install configuration on physical laptop
  modules = {
    dev.lang.ides = [ "go" ];
    hardware = {
      grub.enable = true;
      docker.enable = true;
      nvidia.enable = true;
    };
    services = {
      backup.enable = true;
      syncthing.enable = true;
    };
  };

}
