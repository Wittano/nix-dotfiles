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
        alacritty.enable = true;
      };
    };
    dev = {
      git = {
        enable = true;
        useGpg = true;
      };
      csharp.enable = true;
      cpp.enable = true;
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
    shell = {
      fish = {
        enable = true;
        default = true;
      };
    };
    services = {
      boinc.enable = true;
      ssh.enable = true;
      syncthing.enable = true;
      redshift.enable = true;
    };
  };

}
