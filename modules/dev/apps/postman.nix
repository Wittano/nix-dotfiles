{ config, pkgs, lib, home-manager, mainUser, ... }:
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
    home-manager.users.${mainUser}.home.packages = with pkgs; [ postman ];
  };
}
