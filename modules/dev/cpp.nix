{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.dev.clion;
in {
  options = {
    modules.dev.clion = {
      enable = mkEnableOption ''
        Enable cpp development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home.packages = with pkgs; [
        cmake
        gcc_multi
        gnumake
        glibc

        # Rust
        rustup

        jetbrains.clion
      ];

      programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
        pc = "cd $HOME/projects/own/cpp";
        prust = "cd $HOME/projects/own/rust";
      };
    };
  };
}
