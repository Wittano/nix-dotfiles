{ config, lib, ... }:
with lib;
{
  options.services.ssh.wittano.enable = mkEnableOption "Enable ssh";

  config = {
    services.openssh = rec {
      enable = config.services.ssh.wittano.enable;
      startWhenNeeded = enable;
      settings.PermitRootLogin = "no";
    };
  };
}
