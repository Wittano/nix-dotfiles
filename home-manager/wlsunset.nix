{
  config,
  lib,
  ...
}:
with lib;
{
  options.services.wlsunset.wittano = {
    enable = mkEnableOption "wlsunset";
    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      description = "Assige wlsunset systemd target to desktop target";
    };
  };

  config = {
    services.wlsunset = {
      enable = config.services.wlsunset.wittano.enable;
      latitude = "51.765";
      longitude = "19.495";
      temperature = {
        day = 6000;
        night = 4300;
      };
      systemdTarget = config.services.wlsunset.wittano.systemdTarget;
    };
  };
}
