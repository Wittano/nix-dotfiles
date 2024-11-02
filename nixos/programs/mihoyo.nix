{ lib, config, inputs, ... }:
with lib;
with lib.my;
let
  cfg = config.programs.mihoyo;

  findGame = name: assert builtins.typeOf name == "string"; lists.any (x: x == name) cfg.games;
in
{
  options.programs.mihoyo = {
    enable = mkEnableOption "Enable Mihoyo games";
    games = mkOption {
      type = with types; listOf (enum [ "genshin" "honkai-railway" ]);
      description = "Select which Mihoyo games should be install";
      default = [ ];
    };
  };

  imports = [
    inputs.aagl.nixosModules.default
  ];

  config = mkIf cfg.enable {
    # Genshin Impact
    programs.anime-game-launcher.enable = findGame "genshin";

    networking.mihoyo-telemetry.block = mkForce true;
    # Honkai Railway
    programs.honkers-railway-launcher.enable = findGame "honkai-railway";
  };
}
