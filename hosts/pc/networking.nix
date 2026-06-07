_:
{
  networking = {
    defaultGateway = "192.168.1.1";
    interfaces.eno1 = {
      ipv4.addresses = [{
        address = "192.168.1.169";
        prefixLength = 24;
      }];
    };
    dhcpcd.enable = false;
    nameservers = [ "192.168.1.8" "1.1.1.1" ];
  };
}
