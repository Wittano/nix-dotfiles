{ lib, unstable, secretDir, ... }:
with lib;
with lib.my;
let
  port = 5232;
  certPath = (secretDir + "/certificate.pem");
  keyPath = (secretDir + "/privatekey.pem");
in
{
  autostart = [ "io.github.alainm23.planify" ];

  config = {
    networking.firewall.interfaces.eno1.allowedTCPPorts = [ port ];

    services = {
      accounts-daemon.enable = true;
      passSecretService.enable = true;
      radicale = {
        enable = true;
        settings = {
          server = {
            hosts = [ "0.0.0.0:${builtins.toString port}" ];
            ssl = true;
            certificate = builtins.toString certPath;
            key = builtins.toString keyPath;
          };
          auth = {
            type = "htpasswd";
            htpasswd_filename = "/var/lib/radicale/users";
            htpasswd_encryption = "bcrypt";
          };
        };
      };
    };

    security.pki.certificateFiles = [ certPath ];

    home-manager.users.wittano.home.packages = with unstable; [ planify ];
  };
}
