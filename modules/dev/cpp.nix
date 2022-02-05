{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.dev.cpp;
in {
  options = {
    modules.dev.cpp = {
      enable = mkEnableOption ''
        Enable cpp development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [ jetbrains.clion ];
  };
}
