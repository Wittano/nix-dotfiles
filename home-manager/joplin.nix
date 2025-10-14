{ lib, config, pkgs, ... }: with lib; {
  options.programs.joplin.enable = mkEnableOption "joplin";

  config = mkIf config.programs.joplin.enable {
    home.packages = [ pkgs.joplin-desktop ];

    desktop.autostart.programs = [ "joplin-desktop" ];
  };
}
