{ config, pkgs, lib, home-manager, username, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.dev.jvm;
in
{
  options = {
    modules.dev.jvm = {
      enable = mkEnableOption ''
        Enable JVM development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home.packages = with pkgs; [ jetbrains.idea-ultimate android-studio graalvm-ce ];

      programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
        pjvm = "cd $HOME/projects/own/jvm";
      };
    };
  };
}
