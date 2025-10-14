{ lib, config, pkgs, ... }: with lib; {
  options.programs.spotify.enable = mkEnableOption "spotify";

  config = mkIf config.programs.spotify.enable {
    home.packages = [ pkgs.spotify ];

    desktop.autostart.programs = [ "spotify" ];
  };
}
