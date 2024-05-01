{ lib, ... }:
with lib;
{
  mkNixNamesFromDir = path: assert builtins.pathExists path;
    builtins.map (x: strings.removeSuffix ".nix" x) (builtins.attrNames (builtins.readDir path));
}
