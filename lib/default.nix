{ lib, system, home-manager, pkgs, unstable, dotfiles, systemStaff, ... }: {
  hosts = import ./hosts.nix { inherit lib system home-manager pkgs unstable dotfiles systemStaff; };
  mapper = import ./mapper.nix { inherit lib; };
  link = import ./link.nix { inherit lib; };
  apps = import ./apps.nix { inherit lib home-manager pkgs dotfiles; };
}
