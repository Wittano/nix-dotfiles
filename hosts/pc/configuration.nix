{ config, pkgs, isDevMode ? false, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  home-manager.users.wittano = ./../../home/pc;

  modules = let
    onlyEnableWithDevMode = {
      enableDevMode = isDevMode;
      enable = true;
    };
  in {
    desktop = {
      openbox = onlyEnableWithDevMode;
      gaming.enable = true;
      apps = {
        rofi = onlyEnableWithDevMode;
        terminator = onlyEnableWithDevMode;
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
      cron.enable = true;
    };
  };

}
