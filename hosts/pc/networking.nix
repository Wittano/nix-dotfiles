{ lib, config, ... }:
with lib;
{
  networking = {
    interfaces.eno1.ipv4.addresses = mkIf config.hardware.virtualization.wittano.enableWindowsVM [
      {
        address = "192.168.1.180";
        prefixLength = 24;
      }
    ];
    nameservers = [ "192.168.1.8" "1.1.1.1" ];
    defaultGateway = mkIf config.hardware.virtualization.wittano.enableWindowsVM {
      address = "192.168.1.1";
      interface = "eno1";
    };
    dhcpcd.enable = mkForce true;
  };
}
