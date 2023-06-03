{ config, lib, pkgs, ownPackages, ... }:
with lib;
let cfg = config.modules.themes.catppuccin;
in {
  options = {
    modules.themes.catppuccin = {
      enable = mkEnableOption ''
        Enable catppuccin theme as system theme
      '';
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages =
      [ pkgs.catppuccin-gtk ownPackages.catppuccin-icon-theme ];
  };
}
