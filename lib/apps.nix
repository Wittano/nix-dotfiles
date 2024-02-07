{ lib, pkgs, dotfiles, home-manager, privateRepo, unstable, ... }: {
  desktopApps = config: cfg:
    let
      sourceDir = ./../modules/desktop/apps;
      appFiles = lib.attrsets.filterAttrs
        (n: v: ((lib.strings.hasSuffix ".nix" n) && v == "regular"))
        (builtins.readDir sourceDir);
    in lib.attrsets.mapAttrs' (n: v: {
      name = builtins.replaceStrings [ ".nix" ] [ "" ] n;
      value = import "${sourceDir}/${n}" {
        inherit cfg privateRepo pkgs dotfiles home-manager unstable config lib;
      };
    }) appFiles;
}

