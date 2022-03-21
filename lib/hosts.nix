{ lib, system, home-manager, unstable, pkgs, dotfiles, ... }:
with lib; {
  mkHost = name:
    nixosSystem rec {
      inherit system;

      specialArgs = { inherit pkgs unstable lib dotfiles; hostName = name; };

      modules = [
        ./../modules
        ./../configuration.nix
        ./../hosts/pc/configuration.nix

        home-manager.nixosModules.home-manager
      ];
    };
}
