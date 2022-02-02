{ config, pkgs, lib, home-manager, mainUser, ... }:
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
    home-manager.users.${mainUser}.home = {
      packages = with pkgs; [ jetbrains.idea-community ];
      file.".ideavimrc".text = ''
        set rnu nu
      ''; 
    };
  };
}
