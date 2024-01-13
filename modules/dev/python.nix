{ config, pkgs, lib, home-manager, unstable, ... }:
with lib;
let cfg = config.modules.dev.pycharm;
in {
  options = {
    modules.dev.pycharm = {
      enable = mkEnableOption ''
        Enable Python development enviroment
      '';
    };
  };

  config = {
    home-manager.users.wittano = {
      home.packages = mkIf cfg.enable
        (with pkgs; [ python3 pipenv poetry jetbrains.pycharm-professional ]);

      programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
        ppython = "cd $HOME/projects/own/python";
        temppy =
          "${pkgs.nixFlakes}/bin/nix flake init --template github:nix-community/poetry2nix";
      };
    };
  };
}
