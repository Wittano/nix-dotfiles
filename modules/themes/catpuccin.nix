{ config, lib, pkgs, ownPackages, ... }:
with lib;
let
  cfg = config.modules.themes.catppuccin;
in
{
  options = {
    modules.themes.catppuccin = {
      enable = mkEnableOption ''
        Enable catppuccin theme as system theme
      '';
    };
  };

  config = mkIf (cfg.enable) {
    home-manager.users.wittano.gtk = {
      enable = true;
      theme = {
        name = "Catppuccin-Purple-Dark";
        package = pkgs.catppuccin-gtk;
      };
      iconTheme = {
        name = "Catppuccin-Mocha-Alt";
        package = ownPackages.catppuccin-icon-theme;
      };
    };
  };
}
