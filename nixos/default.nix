{ ... }: {
  imports = [
    ./desktop
    ./boot
    ./hardware
    ./networking
    ./programs
    ./services
    ./secrets.nix
    ./security
    ./specialisation.nix
  ];
}
