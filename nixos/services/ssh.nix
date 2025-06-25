{ config, lib, ... }:
with lib;
{
  options.services.ssh.wittano.enable = mkEnableOption "Enable ssh";

  config = {
    services.openssh = rec {
      inherit (config.services.ssh.wittano) enable;

      startWhenNeeded = enable;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        DenyUsers = [ "wittano" ];
        DenyGroups = [ "wheel" ];
      };
    };
  };
}
