{ config, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.terminator;
in {
  options.modules.desktop.apps.terminator = {
    enable = mkEnableOption "Enable terminator";
  };

  config = mkIf cfg.enable {
    environment.variables.TERM = "terminator";

    home-manager.users.wittano = {
      home.packages = with pkgs; [ terminator ];

      xdg.configFile.terminator.source = dotfiles.terminator;
    };
  };
}
