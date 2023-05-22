{ config, pkgs, lib, home-manager, ... }:
with lib;
let cfg = config.modules.dev.go;
in {
  options = {
    modules.dev.go = {
      enable = mkEnableOption ''
        Enable goland as user package
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [ jetbrains.goland ];
  };

}
