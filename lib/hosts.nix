{ lib, system, home-manager, unstable, pkgs, dotfiles, ... }:
with lib; {
  mkHost = name:
    nixosSystem {
      inherit system;

      specialArgs = { inherit pkgs unstable lib dotfiles; hostName = name; };

      modules = [
        ./../modules
        ./../configuration.nix
        ./../hosts/${name}/configuration.nix

        home-manager.nixosModules.home-manager
      ];
    };
}
