{ lib, ... }: rec {
  inherit (lib.attrsets) mapAttrsToList filterAttrs;
  inherit (lib.lists) flatten any;
  inherit (lib.strings) hasSuffix hasPrefix;

  importModulesPath = path: builtins.filter (e: e != null) 
  (flatten (mapAttrsToList
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
      (filterAttrs (n: v: n != "apps" && n != "utils" && n != "plugins") (builtins.readDir path))));
}
