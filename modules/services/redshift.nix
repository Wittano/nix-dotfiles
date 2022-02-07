{ config, pkgs, lib, ... }:
with lib;
let cfg = config.modules.services.redshift;
in {
  options = {
    modules.services.redshift = {
      enable = mkEnableOption ''
        Enable redshfit as user deamon
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      services.redshift = {
        enable = true;
        latitude = "50.50";
        longitude = "23.41";
        provider = "manual";
        temperature = {
          day = 6000;
          night = 4300;
        };
      };
    };
  };
}
