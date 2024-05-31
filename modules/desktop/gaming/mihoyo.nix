{ lib, config, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming.mihoyo;
  gamingCfg = config.modules.desktop.gaming;
in
{
  options = {
    modules.desktop.gaming.mihoyo = {
      enable = mkEnableOption "Enable Mihoyo games";
    };
  };

  config = mkIf (cfg.enable && gamingCfg.enable) {
    # Genshin Impact
    programs.anime-game-launcher.enable = true;

    # Honkai Railway
    programs.honkers-railway-launcher.enable = true;
  };
}
