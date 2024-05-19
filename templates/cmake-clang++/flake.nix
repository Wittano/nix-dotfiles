{
  description = "cmake-clang++";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          package.default = pkgs.callPackage ./nix/pkg.nix { };
          devShells.default = pkgs.callPackage ./nix/shell.nix { };
        }) // { nixosModules.default = ./nix/module.nix; };
}
