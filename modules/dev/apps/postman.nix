{ config, pkgs, lib, home-manager, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.dev.apps.postman;
in {
  options = {
    modules.dev.apps.postman = {
      enable = mkEnableOption ''
        Enable Postman - API Client Tester
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = with pkgs; [ postman ];
  };
}
