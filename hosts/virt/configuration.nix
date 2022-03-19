{ config, pkgs, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  home-manager.users.wittano = ./../../home/pc;

  modules = {
    desktop = {
      openbox.enable = true;
      apps = {
        rofi.enable = true;
        zeal.enable = true;
        alacritty.enable = true;
      };
    };
    services = {
      ssh.enable = true;
      redshift.enable = true;
    };
  };

}
