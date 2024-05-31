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
      enable = mkEnableOption "Install unrelated(with Steam, lutris or other launchers) games";
    };
  };

  config = mkIf (cfg.enable && gamingCfg.enable) {
    home-manager.users.wittano.home.packages = with unstable; [
      # Games
      prismlauncher # Minecraft launcher
      xivlauncher # FFXIV launcher
      osu-lazer # osu!lazer
      airshipper # Veloren
      mindustry # Mindustry
    ];
  };
}
