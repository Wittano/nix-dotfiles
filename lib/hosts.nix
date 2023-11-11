{ lib, system, home-manager, unstable, pkgs, dotfiles, systemStaff, inputs, ownPackages, ... }:
with lib;
with lib.my; {
  mkHost = { name, isDevMode ? false, username ? "wittano" }:
    nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode systemStaff username inputs ownPackages;
        hostName = name;
      };

      modules =
        let hostName = builtins.replaceStrings [ "-dev" ] [ "" ] name;
        in [
          ./../configuration.nix
          ./../hosts/${hostName}/configuration.nix

          inputs.filebot.nixosModules."filebot"
          home-manager.nixosModules.home-manager
        ] ++ (imports.importModulesPath ./../modules);
    };
}
