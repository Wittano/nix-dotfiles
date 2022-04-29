{ config, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.ulauncher;
in {
  options.modules.desktop.apps.ulauncher = {
    enable = mkEnableOption "Enable ulauncher";
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home.packages = with pkgs; [ ulauncher ];
    };
  };
}
