{ config, pkgs, ... }:
with pkgs;
with lib;
let cfg = config.modules.themes.gruvbox;
in
{
  options = {
    modules.themes.gruvbox = {
      enable = mkEnableOption ''
        Enable gruvbox theme as system theme
      '';
    };
  };

  config = mkIf (cfg.enable) {
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
