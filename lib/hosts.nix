{ lib, system, pkgs, unstable, inputs, secretDir, ... }:
with lib;
with lib.my;
{
  mkHost = name:
    let
      splitName = strings.splitString "-" name;
      hostname = builtins.head splitName;
    in
    inputs.nixpkgs.lib.nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib inputs system hostname secretDir;
        templateDir = ./../templates;
      };

      modules =
        let
          hostnameNoDev = strings.removeSuffix "-dev" hostname;
        in
        [
          ./../hosts/${hostnameNoDev}/configuration.nix

          inputs.catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default

          ../nixos
        ];
    };
}
