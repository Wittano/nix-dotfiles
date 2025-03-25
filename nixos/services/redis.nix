{ config, lib, ... }:
with lib;{
  options.services.redis.wittano.enable = mkEnableOption "Own redis configuration";

  config = mkIf config.services.redis.wittano.enable {
    services.redis = {
      openFirewall = true;
      maxclients = 10;

      servers.homelab = {
        enable = true;
      };
    };
  };
}
