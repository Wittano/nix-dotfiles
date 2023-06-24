{ config, pkgs, lib, home-manager, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.dev.jvm;
in {
  options = {
    modules.dev.jvm = {
      enable = mkEnableOption ''
        Enable JVM development enviroment
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
