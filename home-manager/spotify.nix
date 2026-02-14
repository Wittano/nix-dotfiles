{ lib, config, pkgs, ... }: with lib; {
  options.programs.spotify = {
    enable = mkEnableOption "spotify";
    enableAutostart = mkEnableOption "spotify on autostart";
  };

  config = mkIf config.programs.spotify.enable {
    home.packages = [ pkgs.spotify ];

    desktop.autostart.programs = mkIf config.programs.spotify.enableAutostart [ "spotify" ];
  };
}
