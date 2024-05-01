{ lib, system, inputs, pkgs, unstable, privateRepo, ... }:
with lib;
let
  dotfilesPath = ./../dotfiles;
in
# TODO I have a big plans for this project (Pls, no refactor)... Big plans (refactor lib function)
attrsets.mapAttrs'
  (n: v: {
    name = strings.removeSuffix ".nix" n;
    value = import (./. + "/${n}") { inherit lib pkgs dotfilesPath privateRepo unstable inputs system; };
  })
  (builtins.readDir ./.)
