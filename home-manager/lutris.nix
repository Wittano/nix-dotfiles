{ lib, config, unstable, ... }:
with lib;
{
  options.programs.lutris.wittano.enable = mkEnableOption "Enable lutris and utilities to run games";

  config = mkIf config.programs.lutris.wittano.enable {
    programs.lutris = {
      enable = true;
      package = unstable.lutris;
      extraPackages = with unstable; [ xdelta xterm steam-run ];
      winePackages = [ wineWow64Packages.full ];
      steamPackage = unstable.steam;
    };
  };
}
