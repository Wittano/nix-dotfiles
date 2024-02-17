{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.gnome;
in {

  options.modules.desktop.gnome = {
    enable = mkEnableOption "Enable Gnome desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

}
