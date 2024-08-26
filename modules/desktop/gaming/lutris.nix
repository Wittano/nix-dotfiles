{ lib, config, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming.lutris;
  gamingCfg = config.modules.desktop.gaming;
in
{
  options = {
    modules.desktop.gaming.lutris = {
      enable = mkEnableOption "Enable lutris and utilties to run games";
    };
  };

  config = mkIf (cfg.enable && gamingCfg.enable) rec {
    home-manager.users.wittano.home.packages = with unstable; [
      # Lutris
      lutris
      xdelta
      xterm
      gnome.zenity

      # Wine
      wineWowPackages.full

      # FSH
      steam-run
    ];

    modules.desktop.gaming.games.installed = home-manager.users.wittano.home.packages ++ [
      "wine"
      "exe$"
    ];
  };
}
