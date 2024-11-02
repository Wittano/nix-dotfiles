{ lib, config, unstable, ... }:
with lib;
{
  options.programs.lutris.enable = mkEnableOption "Enable lutris and utilties to run games";

  config = mkIf config.programs.lutris.enable {
    home.packages = with unstable; [
      # Lutris
      lutris
      xdelta
      xterm

      # Wine
      wineWowPackages.full

      # FSH
      steam-run
    ];
  };
}
