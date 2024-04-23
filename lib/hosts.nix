{ lib, system, pkgs, unstable, dotfiles, privateRepo, inputs, imports, ... }:
with lib;
with lib.my;
{
  mkHost = { name, isDevMode ? false }:
    let
      desktops = string.mkNixNamesFromDir ./../modules/desktop/wm;
      findDesktop =
        let
          devSuffix = strings.optionalString (strings.hasSuffix "dev" name) "-(dev)$";
        in
        builtins.any (x: (builtins.match "^([a-z]+)-(${x})${devSuffix}" name) != null) desktops;

      splitName = strings.splitString "-" name;
      desktopName = strings.optionalString findDesktop (builtins.elemAt splitName 1);
      hostname = builtins.head splitName;
    in
    inputs.nixpkgs.lib.nixosSystem rec {
      inherit system;

      specialArgs = {
        inherit pkgs unstable lib dotfiles isDevMode inputs privateRepo system hostname desktopName;
        secretDir = ./../secrets;
        templateDir = ./../templates;
      };

      modules =
        let
          hostnameNoDev = string.removeSuffix "-dev" hostname;
        in
        [
          ./../configuration.nix
          ./../hosts/${hostnameNoDev}/configuration.nix

          inputs.filebot.nixosModules.default
          inputs.agenix.nixosModules.default
          inputs.nixvim.nixosModules.nixvim
          inputs.aagl.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
        ] ++ (imports.importModulesPath ./../modules);
    };
}
