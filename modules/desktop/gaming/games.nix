{ lib, config, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming.games;
  gamingCfg = config.modules.desktop.gaming;

  fixedMindustry = unstable.mindustry.override {
    gradle = unstable.gradle_7;
  };

  games = with unstable; [
    # Games
    osu-lazer # osu!lazer
    airshipper # Veloren
    fixedMindustry # Mindustry
    xivlauncher # FF XIV
  ];
in
{
  options = {
    modules.desktop.gaming.games = {
      enable = mkEnableOption "Install unrelated(with Steam, lutris or other launchers) games";
    };
  };

  config = mkIf (cfg.enable && gamingCfg.enable) {
    home-manager.users.wittano.home.packages = games;

    # Install wacom drivers if osu-lazor is installed
    modules.hardware.wacom.enable = lists.any (x: strings.hasPrefix "osu" x.name) games;
  };
}
