{ lib, config, pkgs, ... }: with lib; {
  options.programs.todoist.enable = mkEnableOption "todoist";

  config = mkIf config.programs.todoist.enable {
    home.packages = [ pkgs.todoist ];

    desktop.autostart.programs = [ "todoist-electron" ];
  };
}
