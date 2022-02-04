{ config, pkgs, lib, home-manager, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.dev.java;
in {
  options = {
    modules.dev.java = {
      enable = mkEnableOption ''
        Enable Java development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home = {
      packages = with pkgs; [ jetbrains.idea-community ];
      file.".ideavimrc".text = ''
        set rnu nu
      ''; 
    };
  };
}
