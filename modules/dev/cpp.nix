{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.clion;
  pCppCommand = commands.createProjectJumpCommand config "$HOME/projects/own/cpp";
in
{
  options = {
    modules.dev.clion = {
      enable = mkEnableOption ''
        Enable cpp development enviroment
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    pCppCommand
    {
      home-manager.users.wittano.home.packages = (with pkgs; [ jetbrains.clion ]);
    }
  ]);
}
