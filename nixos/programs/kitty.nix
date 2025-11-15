{ config, lib, pkgs, ... }:
with lib;
{
  options.programs.kitty.wittano.enable = mkEnableOption "Enable custom kitty config";

  config = mkIf config.programs.kitty.wittano.enable {
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };

    home-manager.users.wittano.programs = rec {
      kitty = {
        enable = true;
        package = pkgs.kitty;
        font = {
          size = 18;
          name = "JetBrains Mono";
          package = pkgs.jetbrains-mono;
        };
        shellIntegration.enableFishIntegration = true;
      };

      fish.shellAliases.ssh = "${kitty.package}/bin/kitten ssh";
    };
  };
}
