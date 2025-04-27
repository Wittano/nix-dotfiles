{ config, lib, ... }:
with lib;{
  options.services.redis.wittano.enable = mkEnableOption "Own redis configuration";

  config = mkIf config.services.redis.wittano.enable {
    services.redis."servers".homelab = {
      enable = true;
      maxclients = 10;
      openFirewall = true;
    };
  };
}
