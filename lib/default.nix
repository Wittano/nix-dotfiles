{ lib, system, inputs, pkgs, unstable, oldPkgs,  ... }:
with lib;
let
  dotfilesPath = ./../dotfiles;
  secretDir = ./../secrets;
in
attrsets.mapAttrs'
  (n: v: {
    name = strings.removeSuffix ".nix" n;
    value = import (./. + "/${n}") { inherit lib pkgs dotfilesPath unstable inputs system secretDir oldPkgs; };
  })
  (builtins.readDir ./.)
