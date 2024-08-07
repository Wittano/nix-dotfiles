{ lib, system, inputs, pkgs, unstable, privateRepo, master, ... }:
with lib;
let
  dotfilesPath = ./../dotfiles;
  secretDir = ./../secrets;
in
attrsets.mapAttrs'
  (n: v: {
    name = strings.removeSuffix ".nix" n;
    value = import (./. + "/${n}") { inherit lib pkgs dotfilesPath privateRepo unstable inputs system secretDir master; };
  })
  (builtins.readDir ./.)
