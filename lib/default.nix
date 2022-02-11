{ lib, system, home-manager, pkgs, unstable, dotfiles, ... }: {
  hosts = import ./hosts.nix { inherit lib system home-manager pkgs unstable dotfiles; };
}
