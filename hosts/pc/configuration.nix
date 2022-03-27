{ config, pkgs, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  home-manager.users.wittano = ./../../home/pc;

  modules = {
    desktop = {
      openbox.enable = true;
      gaming.enable = true;
      apps = {
        rofi.enable = true;
        zeal.enable = true;
      };
    };
    hardware = {
      wacom.enable = true;
      virtualization.enable = true;
      nvidia.enable = true;
    };
    services = {
      boinc.enable = true;
      ssh.enable = true;
      syncthing.enable = true;
      redshift.enable = true;
    };
  };

}
