{ config, lib, pkgs, ... }:
with lib;
{
  options.programs.kitty.wittano.enable = mkEnableOption "Enable custom kitty config";

  config = mkIf config.programs.kitty.wittano.enable rec {
    programs.kitty = {
      enable = true;
      package = pkgs.kitty;
      font = {
        size = 18;
        name = "JetBrains Mono";
        package = pkgs.jetbrains-mono;
      };
      shellIntegration.enableFishIntegration = true;
    };

    programs.fish.shellAliases.ssh = "${programs.kitty.package}/bin/kitten ssh";
  };
}
