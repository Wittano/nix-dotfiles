{ config, pkgs, lib, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.jvm;
  andoridStudio = lists.optionals cfg.enableAndroid (with pkgs; [ android-studio ]);
  pjvmCommand = commands.createProjectJumpCommand config "$HOME/projects/own/jvm";
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

  config = mkIf cfg.enable
    (mkMerge [
      pjvmCommand
      {
        home-manager.users.wittano.home.packages = with pkgs; [ jetbrains.idea-ultimate ] ++ andoridStudio;
      }
    ]);
}
