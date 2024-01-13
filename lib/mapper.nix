{ lib }: rec {
  inherit (lib.attrsets) filterAttrs;

  mapDirToAttrs = path:
    builtins.mapAttrs (n: v:
      let
        newPath = "${path}/${n}";
        sourceAttrs = { source = newPath; };
      in if v == "regular" then
        sourceAttrs
      else
        sourceAttrs // mapDirToAttrs newPath)
    (filterAttrs (n: v: n != ".git") (builtins.readDir path));
}
