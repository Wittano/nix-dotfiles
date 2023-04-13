# TODO Rename "pc" profile
{ config, pkgs, isDevMode ? false, ... }: {

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

  modules =
    let
      enableWithDevMode = {
        enableDevMode = isDevMode;
        enable = true;
      };
    in
    {
      desktop = {
        qtile = enableWithDevMode;
        apps.tmux = enableWithDevMode;
      };
      dev = {
        python.enable = true;
        go.enable = true;
        cpp.enable = true;
      };
      hardware = {
        sound.enable = true;
        grub.enable = true;
        wacom.enable = true;
        virtualization = {
          enable = true;
          enableWindowsVM = true;
        };
        nvidia.enable = true;
        bluetooth.enable = true;
      };
      services = {
        boinc.enable = true;
        backup.enable = true;
        ssh.enable = true;
        syncthing.enable = true;
        redshift.enable = true;
        prometheus.enable = true;
      };
    };

}
