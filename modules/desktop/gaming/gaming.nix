{ config, pkgs, home-manager, lib, unstable, ... }:
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
      enableAdditionalDisk = mkEnableOption ''
        Add special disk to configuration      
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [
      # Lutris
      lutris
      xdelta
      xterm
      gnome.zenity

      # Wine
      bottles

      # FSH
      steam-run

      # Games
      minecraft
    ];

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

    programs.steam.enable = true;

    # For Genshin Impact
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

    fileSystems = mkIf (cfg.enableAdditionalDisk) {
      "/mnt/gaming" = {
        device = "/dev/disk/by-label/GAMING";
        fsType = "ext4";
      };
    };
  };

}
