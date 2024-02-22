{ config, pkgs, lib, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.pycharm;
  ppythonCommand = commands.createProjectJumpCommand config "$HOME/projects/own/python";
in
{
  options = {
    modules.dev.pycharm = {
      enable = mkEnableOption ''
        Enable Python development enviroment
      '';
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    ppythonCommand
    {
      home-manager.users.wittano = {
        home.packages = with pkgs; [ jetbrains.pycharm-professional ];

        programs.fish.shellAliases.tpython =
          "${pkgs.nixFlakes}/bin/nix flake init --template github:nix-community/poetry2nix";
      };
    }
  ]);
}
