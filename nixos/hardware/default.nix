{ ... }: {
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
    ./docker.nix
    ./nvidia.nix
    ./printer.nix
    ./samba.nix
    ./sound.nix
    ./virtualization
  ];
}
