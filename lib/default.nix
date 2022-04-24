{ lib, system, home-manager, pkgs, unstable, dotfiles, ... }: {
  hosts = import ./hosts.nix { inherit lib system home-manager pkgs unstable dotfiles; };
  mapper = import ./mapper.nix { inherit lib; };
  link = import ./link.nix { inherit lib; };
}
