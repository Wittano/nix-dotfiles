{ config, pkgs, isDevMode ? false, username ? "wittano", ... }: {

  imports = [ ./hardware.nix ./networking.nix ];

  home-manager.users.wittano = ./../../home/pc;

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

  # No JAVA/JVM technologies
  assertions = [
    {
      assertion = !config.modules.dev.jvm.enable;
      message = "Java/JVM technologies doesn't allow in this profile";
    }
  ];

  modules =
    let
      enableWithDevMode = {
        enable = true;
        enableDevMode = isDevMode;
      };
    in
    {
      desktop = {
        qtile = enableWithDevMode;
        gaming.enable = true;
        gaming.enableAdditionalDisk = true;
      };
      editors.neovim.enable = true;
      dev = {
        goland.enable = true;
        pycharm.enable = true;
      };
      hardware = {
        sound.enable = true;
        grub.enable = true;
        wacom.enable = true;
        virtualization = {
          enable = true;
          enableDocker = true;
        };
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
        syncthing.enable = true;
        redshift.enable = true;
        prometheus.enable = true;
        filebot.enable = true;
      };
    };

}
