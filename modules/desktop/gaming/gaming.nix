{ config, pkgs, home-manager, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.gaming;
in
{
  options = {
    modules.desktop.gaming = {
      enable = mkEnableOption ''
        Enable games tools
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [
      steam
      steam-run
      lutris
      xdelta
      xterm
      gnome.zenity

      # Games
      minecraft
    ];

    networking.extraHosts = ''
      0.0.0.0 log-upload-os.mihoyo.com
      0.0.0.0 overseauspider.yuanshen.com
      0.0.0.0 uspider.yuanshen.com
      0.0.0.0 prd-lender.cdp.internal.unity3d.com
      0.0.0.0 thind-prd-knob.data.ie.unity3d.com
      0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
      0.0.0.0 cdp.cloud.unity3d.com
      0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com
    '';

    fileSystems = {
      "/mnt/gaming" = {
        device = "/dev/disk/by-label/GAMING";
        fsType = "ext4";
      };
    };
  };

}
