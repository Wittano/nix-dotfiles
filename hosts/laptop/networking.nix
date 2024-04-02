{ ... }: {
  networking = {
    nameservers = [ "192.168.1.8" "1.1.1.1" ];
    firewall = {
      enable = true;
      allowPing = false;
    };
  };

}
