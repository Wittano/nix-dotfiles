{ inputs, lib, pkgs, ... }: with lib;
with lib.my; let
  shellPkgs = import inputs.nixpkgs-unstable {
    inherit system;

    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };
  names = lib.my.string.mkNixNamesFromDir ./shells;
  mkShellAttrs = name: {
    inherit name;
    value = pkgs.callPackage (./shells + "/${name}.nix") { unstable = shellPkgs; };
  };
in
builtins.listToAttrs (builtins.map mkShellAttrs names)
