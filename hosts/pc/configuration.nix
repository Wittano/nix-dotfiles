{ config, pkgs, lib, unstable, home-manager, ... }:
let
  inherit (builtins) toFile;

  homeDir = "/home/wittano";
in {

  imports = [ ./hardware.nix ./networking.nix ];

  config.modules = {
    
  };

}
