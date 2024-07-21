{ lib, ... }: with lib; with lib.my; let
  templatesDirs = builtins.attrNames
    (lib.filterAttrs (n: v: v == "directory")
      (builtins.readDir ./templates));

  templates = lists.forEach templatesDirs (name: {
    inherit name;

    value = {
      path = ./templates/${name};
      description = "Template for ${name}";
    };
  });
in
builtins.listToAttrs templates
