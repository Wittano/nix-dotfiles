{ lib, system, inputs, ... }:
with lib;
with lib.my;
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

  boot.supportedFilesystems.nfs = true;

  programs.droidcam.enable = true;

  modules = {
    desktop.gaming = {
      enable = true;
      disk.enable = true;
      steam = {
        enable = true;
        enableScripts = true;
      };
      lutris.enable = true;
      games.enable = true;
      mihoyo = {
        enable = true;
        games = [ "honkai-railway" ];
      };
      minecraft.enable = true;
    };
    dev = {
      lang.ides = [ "go" "fork" "python" ];
      neovim.enable = true;
    };
    hardware = rec {
      grub.enableMultiBoot = true;
      sound.enable = true;
      virtualization = mkIf (!grub.enableMultiBoot) {
        enable = true;
        enableWindowsVM = true;
      };
      grub = {
        enable = true;
        theme = inputs.honkai-railway-grub-theme.packages.${system}.dr_ratio-grub-theme;
      };
      nvidia.enable = true;
      docker.enable = true;
    };
    services = {
      boinc.enable = true;
      backup.enable = true;
      rss.enable = true;
      syncthing.enable = true;
      redshift.enable = true;
      filebot.enable = true;
    };
  };

}
