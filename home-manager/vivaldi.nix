{ lib, config, pkgs, ... }: with lib; {
  options.programs.vivaldi.wittano.enable = mkEnableOption "vivaldi";

  config = mkIf config.programs.vivaldi.wittano.enable {
    home.packages = with pkgs; [ vivaldi vivaldi-ffmpeg-codecs ];

    desktop.autostart.programs = [ "vivaldi" ];
  };
}
