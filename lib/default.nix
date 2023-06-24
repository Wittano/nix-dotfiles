{ lib, system, home-manager, pkgs, unstable, dotfiles, systemStaff, inputs, ... }: {
  hosts = import ./hosts.nix { inherit lib system home-manager pkgs unstable dotfiles systemStaff inputs; };
  mapper = import ./mapper.nix { inherit lib; };
  link = import ./link.nix { inherit lib; };
  apps = import ./apps.nix { inherit lib home-manager pkgs dotfiles; };
  imports = import ./imports.nix { inherit lib; };
}
