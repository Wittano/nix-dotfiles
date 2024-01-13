{ lib, system, inputs, ... }:
let
  ownPackages = inputs.wittano-repo.packages.x86_64-linux;
  mkPkgs = p:
    import p {
      inherit system;

      config.allowUnfree = true;
    };

  pkgs = mkPkgs inputs.nixpkgs;
  unstable = mkPkgs inputs.nixpkgs-unstable;

  mapper = import ./mapper.nix { inherit lib; };
  imports = import ./imports.nix { inherit lib; };

  dotfiles = mapper.mapDirToAttrs inputs.wittano-dotfiles;

  home-manager = inputs.home-manager;
in {
  inherit mapper imports;

  hosts = import ./hosts.nix {
    inherit lib system pkgs unstable dotfiles inputs ownPackages imports;
  };
  link = import ./link.nix { inherit lib; };
  apps = import ./apps.nix {
    inherit lib home-manager pkgs dotfiles ownPackages unstable;
  };
}
