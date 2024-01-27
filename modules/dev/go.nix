{ config, pkgs, lib, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.goland;
  pgoCommand = commands.createProjectJumpCommand config "$HOME/projects/own/go";
in
{
  options = {
    modules.dev.goland = {
      enable = mkEnableOption ''
        Enable goland as user package
      '';
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    pgoCommand
    {
      home-manager.users.wittano = {
        home.packages = mkIf cfg.enable (with pkgs; [ jetbrains.goland ]);
        programs.fish.shellAliases.tempgo =
          "${pkgs.nixFlakes}/bin/nix flake init --template github:Wittano/nix-template#go";
      };
    }
  ]);
}
