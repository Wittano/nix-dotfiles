{ lib, config, unstable, ... }:
with lib;
let
  cfg = config.modules.desktop.gaming.lutris;
in
{
  options = {
    modules.desktop.gaming.lutris = {
      enable = mkEnableOption "Enable lutris and utilties to run games";
    };
  };

  config = mkIf cfg.enable {
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

    # services.picom.wittano.excpetions = home.packages ++ [
    #   "wine"
    #   "\.exe$"
    # ];
  };
}
