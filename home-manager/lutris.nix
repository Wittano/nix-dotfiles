{ lib, config, unstable, ... }:
with lib;
{
  options.programs.lutris.wittano.enable = mkEnableOption "Enable lutris and utilties to run games";

  config = mkIf config.programs.lutris.wittano.enable {
    programs.lutris = {
      enable = true;
      package = unstable.lutris;
      extraPackages = with unstable; [ xdelta xterm steam-run ];
      winePackages = with unstable.wineWowPackages; [ full ];
      steamPackage = unstable.steam;
    };
  };
}
