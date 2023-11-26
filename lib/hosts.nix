{ lib, system, home-manager, unstable, pkgs, dotfiles, systemStaff, inputs, ownPackages, ... }:
with lib;
with lib.my; {
  mkHost = { name, isDevMode ? false, username ? "wittano" }:
    nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode systemStaff username inputs ownPackages;
        hostName = name;
        agenix = inputs.agenix;
        # TODO Set option for other keys for diffrent hosts
        secretsFile = ./../secrets/syncthing.age;
      };

      modules =
        let hostName = builtins.replaceStrings [ "-dev" ] [ "" ] name;
        in [
          ./../configuration.nix
          ./../hosts/${hostName}/configuration.nix

          inputs.filebot.nixosModules."filebot"
          inputs.agenix.nixosModules.default
          inputs.nixvim.nixosModules.nixvim
          home-manager.nixosModules.home-manager
        ] ++ (imports.importModulesPath ./../modules);
    };
}
