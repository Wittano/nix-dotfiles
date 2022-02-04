{ lib, system, home-manager, unstable, pkgs, ... }:
with lib; {
  mkHost = name:
    nixosSystem {
      inherit system;

      specialArgs = { inherit pkgs unstable lib; };

      modules = [
        ./../modules
        ./../configuration.nix
        ./../hosts/${name}/configuration.nix

        home-manager.nixosModules.home-manager
      ];
    };
}
