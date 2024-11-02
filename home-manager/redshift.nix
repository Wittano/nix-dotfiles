{ config, lib, ... }:
with lib;
{
  options.services.redshift.wittano.enable = mkEnableOption "custom redshift config";

  config = {
    services.redshift = {
      enable = config.services.redshift.wittano.enable;
      latitude = "50.50";
      longitude = "23.41";
      provider = "manual";
      temperature = {
        day = 6000;
        night = 4300;
      };
      settings = {
        redshift = {
          brightness-day = 0.85;
          brightness-night = 0.7;
          transition = 1;
          adjustment-method = "randr";
        };
      };
    };
  };
}
