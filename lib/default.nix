{ lib, system, inputs, pkgs, unstable, privateRepo, ... }:
let
  mapper = import ./mapper.nix { inherit lib pkgs; };
  imports = import ./imports.nix { inherit lib; };

  dotfilesPath = ./../dotfiles;
  dotfiles = mapper.mapDirToAttrs dotfilesPath;

  home-manager = inputs.home-manager;
in
{
  inherit mapper imports;

  hosts = import ./hosts.nix {
    inherit lib system pkgs unstable dotfiles inputs privateRepo imports;
  };
  link = import ./link.nix { inherit lib pkgs dotfiles dotfilesPath; };
  pkgs = import ./pkgs.nix { inherit lib pkgs; };
  desktop = import ./desktop.nix { inherit lib pkgs home-manager dotfiles privateRepo unstable; };
}
