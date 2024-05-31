{ system, inputs, ... }:
{

  imports = [ ./hardware.nix ];

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

  modules = {
    desktop.gaming = {
      enable = true;
      disk.enable = true;
      scripts.enable = true;
      enableMihoyoGames = true;
    };
    editors.neovim.enable = true;
    dev.lang = {
      ides = [ "go" "sql" ];
      lang = [ "fork" ];
    };
    hardware = {
      sound.enable = true;
      grub = {
        enable = true;
        theme = inputs.honkai-railway-grub-theme.packages.${system}.dr_ratio-grub-theme;
      };
      wacom.enable = true;
      nvidia.enable = true;
      virtualization = {
        enable = true;
        enableWindowsVM = true;
      };
      docker.enable = true;
    };
    services = {
      boinc.enable = true;
      backup.enable = true;
      syncthing.enable = true;
      redshift.enable = true;
      filebot.enable = true;
      polkit.enable = true;
    };
  };

}
