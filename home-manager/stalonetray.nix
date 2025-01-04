{ config, lib, ... }:
with lib;
{
  options.services.stalonetray.wittano.enable = mkEnableOption "Custom stalonetray configuration";

  config = {
    services.stalonetray = {
      enable = config.services.stalonetray.wittano.enable;
      config = {
        background = "#24273a";
        icon_size = 28;
        geometry = "1x1+900+19";
      };
    };
  };
}
