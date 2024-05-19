{ lib, system, inputs, pkgs, unstable, privateRepo, ... }:
with lib;
let
  dotfilesPath = ./../dotfiles;
in
attrsets.mapAttrs'
  (n: v: {
    name = strings.removeSuffix ".nix" n;
    value = import (./. + "/${n}") { inherit lib pkgs dotfilesPath privateRepo unstable inputs system; };
  })
  (builtins.readDir ./.)
