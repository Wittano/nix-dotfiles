{ lib, system, home-manager, unstable, pkgs, dotfiles, systemStaff, wittanoRepo, fileMover, ... }:
with lib;
with lib.my; {
  mkHost = { name, isDevMode ? false, username ? "wittano" }:
    nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode systemStaff username;
        hostName = name;
        ownPackages = wittanoRepo.packages.x86_64-linux;
      };

      modules =
        let hostName = builtins.replaceStrings [ "-dev" ] [ "" ] name;
        in [
          ./../configuration.nix
          ./../hosts/${hostName}/configuration.nix

          fileMover.nixosModules."file-mover"
          home-manager.nixosModules.home-manager
        ] ++ (imports.importModulesPath ./../modules);
    };
}
