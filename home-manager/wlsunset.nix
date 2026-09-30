{
  config,
  lib,
  ...
}:
with lib;
{
  options.services.wlsunset.wittano.enable = mkEnableOption "wlsunset";
  config = {
    services.wlsunset = {
      enable = config.services.wlsunset.wittano.enable;
      latitude = "51.765";
      longitude = "19.495";
      temperature = {
        day = 6000;
        night = 4300;
      };
    };
  };
}
