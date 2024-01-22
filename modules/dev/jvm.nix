{ config, pkgs, lib, home-manager, ... }:
with lib;
let
  cfg = config.modules.dev.jvm;
  andoridStudio = lists.optionals cfg.enableAndroid [ andorid-studio ];
in
{
  options = {
    modules.dev.jvm = {
      enable = mkEnableOption ''
        Enable JVM development enviroment
      '';
      enableAndroid = mkEnableOption ''
        Enable Android development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home.packages = with pkgs; [ jetbrains.idea-ultimate ] ++ andoridStudio;

      programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
        pjvm = "cd $HOME/projects/own/jvm";
      };
    };
  };
}
