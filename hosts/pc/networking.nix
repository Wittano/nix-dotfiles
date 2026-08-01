_: {
  networking = {
    dhcpcd.enable = true;
    nameservers = [
      "192.168.1.8"
      "1.1.1.1"
    ];
  };
}
