{ config, pkgs, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  modules = {
    desktop = {
      openbox.enable = true;
      apps = {
        rofi.enable = true;
        alacritty.enable = true;
      };
    };
    services = {
      ssh.enable = true;
      redshift.enable = true;
    };

  };

}
