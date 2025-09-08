{ config, lib, ... }: with lib; {
  options.services.ntopng.wittano.enable = mkEnableOption "ntopng";

  config = mkIf config.services.ntopng.wittano.enable {
    services.ntopng = {
      enable = true;
      httpPort = 2312;
    };
  };
}
