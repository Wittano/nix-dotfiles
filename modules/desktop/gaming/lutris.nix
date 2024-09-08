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

      # Wine
      wineWowPackages.full

      # FSH
      steam-run
    ];

    networking.mihoyo-telemetry.block = !gamingCfg.mihoyo.enable;

    networking.extraHosts = mkIf (gamingCfg.mihoyo.enable) ''
      0.0.0.0 globaldp-prod-os01.zenlesszonezero.com
      0.0.0.0 apm-log-upload.mihoyo.com
    '';

    modules.desktop.gaming.games.installed = home-manager.users.wittano.home.packages ++ [
      "wine"
      "\.exe$"
    ];
  };
}
