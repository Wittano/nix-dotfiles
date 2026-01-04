{ ... }: {
  imports = [
    ./bluetooth.nix
    ./nfs.nix
    ./bootloader.nix
    ./docker.nix
    ./nvidia.nix
    ./amd.nix
    ./printer.nix
    ./samba.nix
    ./pipewire.nix
    ./virtualization
    ./podman.nix
  ];
}
