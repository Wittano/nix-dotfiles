{ ... }:
{
  imports = [
    ./bluetooth.nix
    ./nfs.nix
    ./bootloader.nix
    ./docker.nix
    ./nvidia.nix
    ./amd.nix
    ./samba.nix
    ./pipewire.nix
    ./virtualization
    ./podman.nix
  ];
}
