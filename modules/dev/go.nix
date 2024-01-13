{ config, pkgs, lib, home-manager, ... }:
with lib;
let cfg = config.modules.dev.goland;
in {
  options = {
    modules.dev.goland = {
      enable = mkEnableOption ''
        Enable goland as user package
      '';
    };
  };

  config = {
    home-manager.users.wittano = {
      home.packages = mkIf cfg.enable (with pkgs; [ jetbrains.goland ]);
      programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
        pgo = "cd $HOME/projects/own/go";
        tempgo =
          "${pkgs.nixFlakes}/bin/nix flake init --template github:Wittano/nix-template#go";
      };
    };
  };

}
