{ lib, system, home-manager, unstable, pkgs, dotfiles, systemStaff, ... }:
with lib; {
  mkHost =  { name, isDevMode ? false }:
    nixosSystem rec {
      inherit system;

      specialArgs = { inherit pkgs unstable lib dotfiles isDevMode systemStaff; hostName = name; };

      modules =
        let
          hostName = builtins.replaceStrings [ "-dev" ] [ "" ] name;
        in
          [
            ./../modules
            ./../configuration.nix
            ./../hosts/${hostName}/configuration.nix

            home-manager.nixosModules.home-manager
          ];
    };
}
