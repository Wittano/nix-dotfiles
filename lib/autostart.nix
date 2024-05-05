{ lib, pkgs, ... }:
with lib;
let
  mkAutostartAttr = { name, args, pkg, path ? [] }:
    let
      split = strings.splitString "-" name;
      secPart = builtins.elemAt split 1;
      gnomeFixedApp = attrsets.optionalAttrs (builtins.head split == "gnome") pkg.gnome.${secPart};
      app = if gnomeFixedApp == { } then pkg.${name} else gnomeFixedApp;

      runtimeInputs = lists.singleton app;
    in
    {
      inherit name;
      path = runtimeInputs ++ path;
      script = "${name} ${args}";
      pkgs = pkg;
    };
in
{
  mkAutostart = { programs, pkg ? pkgs, path ? [] }: builtins.map
    (program:
      let
        split = strings.splitString " " program;
      in
      mkAutostartAttr {
        inherit pkg path;

        name = builtins.head split;
        args = strings.optionalString
          (builtins.length split > 1)
          (builtins.concatStringsSep " " (builtins.tail split));
      })
    programs;
}
