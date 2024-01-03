{ lib, system, pkgs, unstable, dotfiles, systemStaff, ownPackages, inputs, imports, ... }: {
  mkHost = { name, isDevMode ? false, username ? "wittano" }:
    inputs.nixpkgs.lib.nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode systemStaff username inputs ownPackages;
        hostName = name;
        # TODO Set option for other keys for diffrent hosts
        secretsFile = ./../secrets/syncthing.age;
      };

      modules =
        let
          hostName = builtins.replaceStrings [ "-dev" ] [ "" ] name;
        in
        [
          ./../configuration.nix
          ./../hosts/${hostName}/configuration.nix

          inputs.filebot.nixosModules."filebot"
          inputs.agenix.nixosModules.default
          inputs.nixvim.nixosModules.nixvim
          inputs.aagl.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ] ++ (imports.importModulesPath ./../modules);
    };
}
