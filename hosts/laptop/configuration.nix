{ config, pkgs, isDevMode ? false, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  modules = {
    desktop = {
      apps.enable = true;
      gnome.enable = true;
    };
    dev.ide.list = [ "go" ];
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
