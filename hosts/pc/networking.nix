{ config, ... }: {
  assertions = [
    {
      assertion = !config.networking.networkmanager.enable;
      message = "NetworkManager cannot be enable, causes problem with spotify interent connection";
    }
  ];

  networking = {

    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.4";
        prefixLength = 24;
      }];
    };

    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.8" "192.168.1.1" "1.1.1.1" ];
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [ 57621 ];
      allowedUDPPorts = [ 5353 ];
    };
  };

}
