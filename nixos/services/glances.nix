{ config, lib, ... }: with lib; {
  options.services.glances.wittano.enable = mkEnableOption "glance";

  config = mkIf config.services.glances.wittano.enable {
    services.glances = {
      enable = true;
      port = 3621;
    };
  };
}
