{ lib, system, inputs, pkgs, unstable, privateRepo, ... }:
let
  mapper = import ./mapper.nix { inherit lib pkgs; };
  imports = import ./imports.nix { inherit lib; };

  dotfiles = mapper.mapDirToAttrs ./../dotfiles;

  home-manager = inputs.home-manager;
in
{
  inherit mapper imports;

  hosts = import ./hosts.nix {
    inherit lib system pkgs unstable dotfiles inputs privateRepo imports;
  };
  link = import ./link.nix { inherit lib; };
  apps = import ./apps.nix {
    inherit lib home-manager pkgs dotfiles privateRepo unstable;
  };
  commands = import ./commands.nix { inherit pkgs lib home-manager; };
  pkgs = import ./pkgs.nix { inherit lib pkgs; };
}
