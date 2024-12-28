{ lib, system, inputs, pkgs, unstable, ... }:
with lib;
let
  secretDir = ./../secrets;
in
attrsets.mapAttrs'
  (n: v: {
    name = strings.removeSuffix ".nix" n;
    value = import (./. + "/${n}") { inherit lib pkgs unstable inputs system secretDir; };
  })
  (builtins.readDir ./.)
