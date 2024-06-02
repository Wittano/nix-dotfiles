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
      enable = mkEnableOption "Install unrelated(with Steam, lutris or other launchers) games";
    };
  };

  config = mkIf (cfg.enable && gamingCfg.enable) {
    home-manager.users.wittano.home.packages = with unstable; [
      # Games
      osu-lazer # osu!lazer
      airshipper # Veloren
      mindustry # Mindustry
    ];
  };
}
