{ config, pkgs, lib, ... }:
with lib;
let cfg = config.modules.themes;
in {
  imports = [ ./dracula.nix ./gruvbox.nix ];

  options = {
    modules.themes = {
      enable = mkEnableOption ''
        Enable GTK and general themes for other applications
      '';
    };
  };
}
