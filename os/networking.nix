{ config, pkgs, ... }: {
  networking = {
    hostName = "nixos";
    useDHCP = false;

    # PC
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.165";
        prefixLength = 24;
      }];
    };

    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" ];
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [ 31416 ];
    };

  };
}
