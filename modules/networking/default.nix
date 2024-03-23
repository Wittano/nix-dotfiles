{ config, pkgs, ... }: {
  networking = {
    hostName = "nixos";
    firewall = {
      allowPing = false;
      rejectPackets = true;
    };
  };
}
