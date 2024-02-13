{ lib, system, pkgs, unstable, dotfiles, privateRepo, inputs, imports, ... }: {
  mkHost = { name, isDevMode ? false }:
    inputs.nixpkgs.lib.nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode inputs privateRepo;
        hostname = name;
        secretDir = ./../secrets;
        templateDir = ./../templates;
      };

      modules =
        let
          hostname = builtins.replaceStrings [ "-dev" ] [ "" ] name;
        in
        [
          ./../configuration.nix
          ./../hosts/${hostname}/configuration.nix

          inputs.filebot.nixosModules."filebot"
          inputs.agenix.nixosModules.default
          inputs.nixvim.nixosModules.nixvim
          inputs.aagl.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ] ++ (imports.importModulesPath ./../modules);
    };
}
