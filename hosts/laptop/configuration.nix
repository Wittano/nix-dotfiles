{ config, pkgs, isDevMode ? false, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  modules =
    let
      enableWithDevMode = {
        enable = true;
        enableDevMode = isDevMode;
      };
    in
    {
      desktop = {
        apps.enable = true;
        qtile = enableWithDevMode;
      };
      editors.neovim.enable = true;
      dev = {
        goland.enable = true;
        clion.enable = true;
      };
      hardware = {
        sound.enable = true;
        grub.enable = true;
        wifi.enable = true;
        virtualization = {
          enable = true;
          enableDocker = true;
        };
        nvidia.enable = true;
      };
      services = {
        backup = {
          enable = true;
          backupDir = "/mnt/backup/wittano.nixos";
        };
        syncthing.enable = true;
        redshift.enable = true;
      };
    };

}
