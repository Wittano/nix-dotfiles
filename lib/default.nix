{ lib, system, home-manager, pkgs, unstable, dotfiles, systemStaff, wittanoRepo, ... }: {
  hosts = import ./hosts.nix { inherit lib system home-manager pkgs unstable dotfiles systemStaff wittanoRepo; };
  mapper = import ./mapper.nix { inherit lib; };
  link = import ./link.nix { inherit lib; };
  apps = import ./apps.nix { inherit lib home-manager pkgs dotfiles; };
}
