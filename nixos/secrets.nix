{ config, lib, system, inputs, secretDir, ... }:
with lib;
with lib.my;
{
  environment.systemPackages = [ inputs.agenix.packages."${system}".default ];
  age = {
    identityPaths = [
      "/etc/ssh/samba.key"
    ];
    secrets.samba = {
      file = secretDir + "/samba.age";
      owner = "root";
      group = "root";
    };
  };

  services.openssh = mkIf (!config.services.ssh.wittano.enable) {
    enable = mkForce true;
    openFirewall = false;
    allowSFTP = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
