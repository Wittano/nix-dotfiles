{ config, pkgs, ... }: {
  networking = {
    hostName = "nixos";
    useDHCP = false;

    # PC
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.160";
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
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
