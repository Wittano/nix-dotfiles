{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.app;
  app = pkgs.callPackage ./pkg.nix { };
in
{
  options = {
    programs.app.enable = mkEnableOption "Enable app";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ app ];
  };
}
