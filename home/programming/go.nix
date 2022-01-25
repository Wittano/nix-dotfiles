{ config, pkgs, lib, ... }:
let
  unstable = (import (fetchTarball
    "https://github.com/nixos/nixpkgs/archive/nixpkgs-unstable.tar.gz") { });

  golandPackages = with pkgs; [ jetbrains.goland gnumake gcc ];
in { home.packages = with pkgs; [ unstable.go_1_17 ] ++ golandPackages; }
