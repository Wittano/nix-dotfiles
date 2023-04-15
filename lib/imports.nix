{ lib, ... }: rec {
  inherit (lib.attrsets) mapAttrsToList filterAttrs;
  inherit (lib.lists) flatten;
  inherit (lib.strings) hasSuffix hasPrefix;

  importModulesPath = path:
    flatten (mapAttrsToList
      (n: v:
        let
          newPath = "${path}/${n}";
        in
        if v == "regular"
        then
          if hasSuffix "nix" newPath
          then newPath
          else null
        else importModulesPath newPath)
      (filterAttrs (n: v: n != "apps" && n != "utils") (builtins.readDir path)));
}
