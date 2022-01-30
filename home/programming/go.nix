{ config, pkgs, unstable, ... }:
let golandPackages = with pkgs; [ jetbrains.goland gnumake gcc ];
in { home.packages = with pkgs; [ unstable.go_1_17 ] ++ golandPackages; }
