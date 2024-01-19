{ config, pkgs, unstable, lib, home-manager, ... }:
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
      enableAndroid = mkEnableOption ''
        Enable Android development enviroment
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home.packages = with unstable;
        [ jetbrains.idea-ultimate ]
        ++ (if cfg.enableAndroid then [ andorid-studio ] else [ ]);

      programs.fish.shellAliases = mkIf (config.modules.shell.fish.enable) {
        pjvm = "cd $HOME/projects/own/jvm";
      };
    };
  };
}
