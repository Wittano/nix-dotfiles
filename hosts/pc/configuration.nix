{ config, pkgs, isDevMode ? false, privateRepo, ... }: {

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
      dev.ide.list = [ "go" ];
      hardware = {
        sound.enable = true;
        grub = {
          enable = true;
          theme = privateRepo.honkai-railway;
        };
        wacom.enable = true;
        nvidia.enable = true;
        bluetooth.enable = true;
        docker.enable = true;
      };
      services = {
        boinc.enable = true;
        backup.enable = true;
        ssh.enable = true;
        syncthing.enable = true;
        redshift.enable = true;
        filebot.enable = true;
        polkit.enable = true;
      };
    };

}
