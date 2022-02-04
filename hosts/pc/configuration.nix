{ config, pkgs, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  home-manager.users.wittano = ./../../home/pc;

  modules = {
    themes = {
      enable = true;
      dracula.enable = true;
    };
    desktop = {
      openbox.enable = true;
      apps = {
        rofi.enable = true;
        zeal.enable = true;
      };
    };
    dev = {
      git.enable = true;
      go = {
        enable = true;
        useGoland = true;
      };
      python = {
        enable = true;
        usePycharm = true;
      };
    };
    editors.neovim.enable = true;
    hardware = {
      wacom.enable = true;
      grub.enable = true;
      virtualization.enable = true;
      sound.enable = true;
      nvidia.enable = true;
    };
    services = {
      boinc.enable = true;
      ssh.enable = true;
      syncthing.enable = true;
    };
  };

}
