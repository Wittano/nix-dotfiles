{ config, pkgs, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  modules = {
    services = {
      ssh.enable = true;
      redshift.enable = true;
    };
  };

}
