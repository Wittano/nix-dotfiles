{ config, pkgs, home-manager, lib, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.alacritty;
in {
  options = {
    modules.desktop.apps.alacritty = {
      enable = mkEnableOption ''
        Enable aclaritty - minimal terminal emulator 
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home.packages = with pkgs; [ alacritty ];

      xdg.configFile."alacritty".source = dotfiles.alacritty;
    };
  };
}
