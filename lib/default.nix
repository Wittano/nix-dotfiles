{ lib, system, inputs, pkgs, unstable, master, ... }:
with lib;
let
  secretDir = ./../secrets;
in
attrsets.mapAttrs'
  (n: v: {
    name = strings.removeSuffix ".nix" n;
    value = import (./. + "/${n}") { inherit lib pkgs unstable inputs system secretDir master; };
  })
  (builtins.readDir ./.)
