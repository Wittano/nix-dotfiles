{ ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  # TODO Added encrypted home and backup directory
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
