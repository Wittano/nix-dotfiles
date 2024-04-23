{ ... }: rec {
  removeSuffix = suffix: source: builtins.replaceStrings [ suffix ] [ "" ] source;

  mkNixNamesFromDir = path: assert builtins.pathExists path;
    builtins.map (x: removeSuffix ".nix" x) (builtins.attrNames (builtins.readDir path));
}
