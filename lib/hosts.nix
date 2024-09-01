{ lib, system, pkgs, unstable, privateRepo, inputs, dotfilesPath, secretDir, master, ... }:
with lib;
with lib.my;
let
  importModulesPath = path:
    let
      ignoredDir = [ "submodules" "utils" "plugins" ];
      source = attrsets.filterAttrs
        (n: _: all (x: x != n) ignoredDir)
        (builtins.readDir path);

      mkModulePath = n: v:
        let newPath = "${path}/${n}";
        in if v == "regular" then
          if strings.hasSuffix "nix" newPath then newPath else null
        else
          importModulesPath newPath;
      modulesList = lists.flatten (attrsets.mapAttrsToList mkModulePath source);
    in
    builtins.filter (e: e != null) modulesList;

  dotfiles = mapper.mapDirToAttrs dotfilesPath;
in
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
        inherit pkgs unstable lib dotfiles isDevMode inputs privateRepo system hostname desktopName secretDir master;
        templateDir = ./../templates;
      };

      modules =
        let
          hostnameNoDev = strings.removeSuffix "-dev" hostname;
        in
        [
          ./../configuration.nix
          ./../hosts/${hostnameNoDev}/configuration.nix

          inputs.catppuccin.nixosModules.catppuccin
          inputs.home-manager.nixosModules.home-manager
        ] ++ (importModulesPath ./../modules);
    };
}
