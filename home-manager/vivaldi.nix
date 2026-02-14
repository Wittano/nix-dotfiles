{ lib, config, pkgs, ... }: with lib; {
  options.programs.vivaldi.wittano = {
    enable = mkEnableOption "vivaldi";
    enableAutostart = mkEnableOption "vivaldi on autostart";
  };

  config = mkIf config.programs.vivaldi.wittano.enable {
    home.packages = with pkgs; [ vivaldi vivaldi-ffmpeg-codecs ];

    desktop.autostart.programs = mkIf config.programs.vivaldi.wittano.enableAutostart [ "vivaldi" ];
  };
}
