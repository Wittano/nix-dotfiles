{ lib }:
with lib;
rec {
  mapDirToAttrs = path:
    builtins.mapAttrs
      (n: v:
        let
          newPath = "${path}/${n}";
          sourceAttrs = { source = newPath; };
        in
        if v == "regular" then
          sourceAttrs
        else
          sourceAttrs // mapDirToAttrs newPath)
      (attrsets.filterAttrs (n: v: n != ".git") (builtins.readDir path));
  }
