{ lib, system, unstable, master, inputs, secretDir, ... }:
with lib;
with lib.my;
{
  mkHost = name:
    let
      splitName = strings.splitString "-" name;
      hostname = builtins.head splitName;

      nixpkgsConfig = { pkgs, ... }: {
        nixpkgs = {
          overlays =
            let
              overlay = import ./../overlays.nix { inherit lib pkgs; };
            in
            inputs.xmonad-contrib.overlays ++ overlay;
          config = {
            allowBroken = false;
            allowUnfree = true;
          };
        };
      };
    in
    inputs.nixpkgs.lib.nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit unstable lib inputs system hostname secretDir master;
        templateDir = ./../templates;
      };

      modules =
        [
          ./../hosts/${hostname}/configuration.nix

          inputs.catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.home-manager
          inputs.agenix.nixosModules.default
          inputs.determinate.nixosModules.default

          ../nixos

          nixpkgsConfig
        ];
    };
}
