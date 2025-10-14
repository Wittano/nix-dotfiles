{ lib, config, pkgs, ... }: with lib; {
  options.programs.pomodoro.enable = mkEnableOption "pomodoro";

  config = mkIf config.programs.pomodoro.enable {
    home.packages = [ pkgs.gnome-pomodoro ];

    desktop.autostart.programs = [ "gnome-pomodoro" ];
  };
}
