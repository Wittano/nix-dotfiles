{ lib, system, inputs, pkgs, unstable, ... }:
let
  ownPackages = inputs.wittano-repo.packages.x86_64-linux;

  mapper = import ./mapper.nix { inherit lib; };
  imports = import ./imports.nix { inherit lib; };

  dotfiles = mapper.mapDirToAttrs ./../dotfiles;

  home-manager = inputs.home-manager;
in
{
  inherit mapper imports;

  hosts = import ./hosts.nix {
    inherit lib system pkgs unstable dotfiles inputs ownPackages imports;
  };
  link = import ./link.nix { inherit lib; };
  apps = import ./apps.nix {
    inherit lib home-manager pkgs dotfiles ownPackages unstable;
  };
  commands = import ./commands.nix { inherit pkgs lib home-manager; };
}
