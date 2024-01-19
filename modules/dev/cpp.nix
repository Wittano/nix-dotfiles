{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.dev.clion;
in
{
  options = {
    modules.dev.clion = {
      enable = mkEnableOption ''
        Enable cpp development enviroment
      '';
    };
  };

  config = {
    home-manager.users.wittano = {
      home.packages = mkIf cfg.enable (with pkgs; [
        cmake
        gcc_multi
        gnumake
        glibc

        # Rust
        rustup # TODO Split rust and cpp configuration

        unstable.jetbrains.clion
      ]);

      programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
        pc = "cd $HOME/projects/own/cpp";
        prust = "cd $HOME/projects/own/rust";
      };
    };
  };
}
