{ config, pkgs, lib, home-manager, ... }:
with lib;
let cfg = config.modules.dev.goland;
in {
  options = {
    modules.dev.goland = {
      enable = mkEnableOption ''
        Enable goland as user package
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [ jetbrains.goland ];
  };

}
