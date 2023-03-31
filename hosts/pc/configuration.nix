{ config, pkgs, isDevMode ? false, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  home-manager.users.wittano = ./../../home/pc;

  modules =
    let
      onlyEnableWithDevMode = {
        enableDevMode = isDevMode;
        enable = true;
      };
    in
    {
      desktop = {
        qtile = onlyEnableWithDevMode;
        apps = {
          tmux = onlyEnableWithDevMode;
        };
      };
      dev = {
        python = {
          enable = true;
          usePycharm = true;
        };
      };
      hardware = {
        sound.enable = true;
        grub.enable = true;
        wacom.enable = true;
        virtualization.enable = true;
        nvidia.enable = true;
        bluetooth.enable = true;
      };
      services = {
        boinc.enable = true;
        ssh.enable = true;
        syncthing.enable = true;
        redshift.enable = true;
        prometheus.enable = true;
      };
    };

}
