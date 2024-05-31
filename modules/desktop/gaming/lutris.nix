{ lib, config, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming.games;
  gamingCfg = config.modules.desktop.gaming;
in
{
  options = {
    modules.desktop.gaming.games = {
      enable = mkEnableOption "Enable lutris and utilties to run games";
    };
  };

  config = mkIf (cfg.enable && gamingCfg.enable) {
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
  };
}
