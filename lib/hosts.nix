{ lib, system, home-manager, unstable, pkgs, dotfiles, systemStaff, inputs, ... }:
with lib;
with lib.my; {
  mkHost = { name, isDevMode ? false, username ? "wittano" }:
    nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode systemStaff username inputs;
        hostName = name;
        ownPackages = inputs.wittano-repo.packages.x86_64-linux;
      };

      modules =
        let hostName = builtins.replaceStrings [ "-dev" ] [ "" ] name;
        in [
          ./../configuration.nix
          ./../hosts/${hostName}/configuration.nix

          inputs.file-mover.nixosModules."file-mover"
          home-manager.nixosModules.home-manager
        ] ++ (imports.importModulesPath ./../modules);
    };
}
