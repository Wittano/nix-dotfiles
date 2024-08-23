{ lib, config, inputs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming.mihoyo;
  gamingCfg = config.modules.desktop.gaming;

  findGame = name: assert builtins.typeOf name == "string"; lists.any (x: x == name) cfg.games;
in
{
  options = {
    modules.desktop.gaming.mihoyo = {
      enable = mkEnableOption "Enable Mihoyo games";
      games = mkOption {
        type = with types; listOf (enum [ "genshin" "honkai-railway" ]);
        description = "Select which Mihoyo games should be install";
        default = [ ];
      };
    };
  };

  imports = [
    inputs.aagl.nixosModules.default
  ];

  config = mkIf (cfg.enable && gamingCfg.enable) {
    # Genshin Impact
    programs.anime-game-launcher.enable = findGame "genshin";

    # Honkai Railway
    programs.honkers-railway-launcher.enable = findGame "honkai-railway";
  };
}
