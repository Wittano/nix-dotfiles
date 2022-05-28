{ ... }: {
  networking = {
    useDHCP = false;

    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.5";
        prefixLength = 24;
      }];
    };

    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.8" "1.1.1.1" ];
    firewall = {
      enable = true;
      allowPing = false;
    };
  };

}
