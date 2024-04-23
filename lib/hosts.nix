{ lib, system, pkgs, unstable, dotfiles, privateRepo, inputs, imports, ... }:
with lib; {
  mkHost = { name, isDevMode ? false }:
    let
      desktops = builtins.map
        (x: builtins.replaceStrings [ ".nix" ] [ "" ] x)
        (builtins.attrNames (builtins.readDir ./../modules/desktop/wm));
      findDesktop = builtins.any (x: (builtins.match "^([a-z]+)-(${x})-*" name) != null) desktops;

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
          hostnameNoDev = builtins.replaceStrings [ "-dev" ] [ "" ] hostname;
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
