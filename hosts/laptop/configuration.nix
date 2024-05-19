{ ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  modules = {
    dev.lang.ides = [ "go" ];
    hardware = {
      grub.enable = true;
      docker.enable = true;
      wifi.enable = true;
      nvidia.enable = true;
    };
    services = {
      backup.enable = true;
      syncthing.enable = true;
    };
  };

}
