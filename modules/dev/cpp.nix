{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.clion;
  pRustCommand = commands.createProjectJumpCommand "$HOME/projects/own/rust";
  pCppCommand = commands.createProjectJumpCommand "$HOME/projects/own/cpp";
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
    pRustCommand
    pCppCommand
    {
      home-manager.users.wittano = {
        home.packages = (with pkgs; [
          # Rust
          rustup # TODO Split rust and cpp configuration

          jetbrains.clion
        ]);
      };
    }
  ]);
}
