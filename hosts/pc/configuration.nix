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
      steam = {
        enable = true;
        enableScripts = true;
      };
      games.enable = true;
      mihoyo.enable = true;
    };
    dev.lang.ides = [ "go" "sql" "fork" ];
    hardware = {
      sound.enable = true;
      virtualization = {
        enable = true;
        enableWindowsVM = true;
      };
      grub = {
        enable = true;
        enableMultiBoot = true;
        theme = inputs.honkai-railway-grub-theme.packages.${system}.dr_ratio-grub-theme;
      };
      nvidia.enable = true;
      docker.enable = true;
    };
    services = {
      boinc.enable = true;
      ssh.enable = true;
      backup.enable = true;
      rss.enable = true;
      syncthing.enable = true;
      redshift.enable = true;
      filebot.enable = true;
    };
  };

}
