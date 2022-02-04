{ lib, system, home-manager, pkgs, unstable, ... }: {
  path = import ./path.nix { inherit lib; };
  hosts = import ./hosts.nix { inherit lib system home-manager pkgs unstable; };
}
