{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.themes.gruvbox;
in {
  options = {
    modules.themes.gruvbox = {
      enable = mkEnableOption ''
        Enable gruvbox theme as system theme
      '';
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      gruvbox-dark-gtk
      gruvbox-dark-icons-gtk
    ];
  };
}
