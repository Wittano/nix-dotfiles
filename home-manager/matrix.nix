{ lib, config, pkgs, ... }: with lib; {
  options.programs.matrix = {
    enable = mkEnableOption "matrix";
    enableAutostart = mkEnableOption "matrix on autostart";
  };

  config = mkIf config.programs.matrix.enable {
    home.packages = [ pkgs.element-desktop ];

    desktop.autostart.programs = mkIf config.programs.matrix.enableAutostart [ "element-desktop" ];
  };
}
