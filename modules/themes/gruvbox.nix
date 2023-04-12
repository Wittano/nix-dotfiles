{ config, pkgs, ... }:
with pkgs;
with lib;
{
  options = {
    modules.themes.gruvbox = {
      enable = mkEnableOption ''
        Enable gruvbox theme as system theme
      '';
    };
  };

  config = {
    environment.systemPackages = with pkgs; [ gruvbox-dark-gtk gruvbox-dark-icons-gtk ];

    home-manager.users.wittano = {
      gtk = {
        enable = true;
        theme = {
          name = "gruvbox-dark";
          package = pkgs.gruvbox-dark-gtk;
        };
        iconTheme = {
          name = "oomox-gruvbox-dark";
          package = pkgs.gruvbox-dark-icons-gtk;
        };
      };
    };
  };
}
