{ lib, system, home-manager, pkgs, unstable, dotfiles, systemStaff, inputs, ... }:
let
  ownPackages = inputs.wittano-repo.packages.x86_64-linux;
in
{
  hosts = import ./hosts.nix { inherit lib system home-manager pkgs unstable dotfiles systemStaff inputs ownPackages; };
  mapper = import ./mapper.nix { inherit lib; };
  link = import ./link.nix { inherit lib; };
  apps = import ./apps.nix { inherit lib home-manager pkgs dotfiles ownPackages; };
  imports = import ./imports.nix { inherit lib; };
}
