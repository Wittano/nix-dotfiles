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

  programs.droidcam.enable = true;

  modules = let
    enableWithDevMode = {
      enable = true;
      enableDevMode = isDevMode;
    };
  in {
    desktop.qtile = enableWithDevMode;
    editors.emacs = enableWithDevMode // { version = "doom"; };
    dev = {
      python.enable = true;
      go.enable = true;
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
