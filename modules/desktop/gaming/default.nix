{ config, pkgs, home-manager, ... }:
with lib;
let
 cfg = config.modules.desktop.gaming;
in {
  options = {
    modules.desktop.gaming = {
      enable = mkEnableOption ''
        Enable games utilites
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [
      steam
      steam-run-native
      lutris
    ];
  };
  
}
