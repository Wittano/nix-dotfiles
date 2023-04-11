{ lib, system, home-manager, unstable, pkgs, dotfiles, systemStaff, wittanoRepo, ... }:
with lib; {
  mkHost = { name, isDevMode ? false, username ? "wittano" }:
    nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode systemStaff username;
        hostName = name;
        ownPackages = wittanoRepo.packages.x86_64-linux;
      };

      modules = let hostName = builtins.replaceStrings [ "-dev" ] [ "" ] name;
      in [
        ./../modules
        ./../configuration.nix
        ./../hosts/${hostName}/configuration.nix

        home-manager.nixosModules.home-manager
      ];
    };
}
