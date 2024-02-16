{ config, pkgs, isDevMode ? false, ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  services.xserver.xrandrHeads = [
    {
      primary = true;
      output = "DVI-D-0";
      monitorConfig = ''
        Option "PreferredMode" "1920x1080"
      '';
    }
    {
      primary = false;
      output = "HDMI-0";
      monitorConfig = ''
        Option "PreferredMode" "1920x1080"
        Option "RightOf" "DVI-D-0"
      '';
    }
  ];

  programs.droidcam.enable = true;

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
        gaming = {
          enable = true;
          enableAdditionalDisk = true;
          enableMihoyoGames = true;
        };
        sddm = {
          enable = true;
          theme = "sugar-candy";
        };
      };
      themes.catppuccin.enable = true;
      dev = {
        jvm.enable = true;
        goland.enable = true;
      };
      editors.neovim.enable = true;
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
        backup = {
          enable = true;
          backupDir = "/mnt/backup/wittano.nixos";
        };
        ssh.enable = true;
        kubernetes.enable = true;
        syncthing.enable = true;
        redshift.enable = true;
        prometheus.enable = true;
        filebot.enable = true;
        polkit.enable = true;
      };
    };

}
