{ config, pkgs, lib, home-manager, ... }:
with lib;
let cfg = config.modules.desktop.apps.zeal;
in {
  options = {
    modules.desktop.apps.zeal = {
      enable = mkEnableOption ''
        Enable zeal - Zeal is an offline documentation browser for software developers.
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [ zeal ];
  };
}
