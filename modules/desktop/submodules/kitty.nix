{ config, pkgs, ... }:
{
  config = {
    home-manager.users.wittano = {
      programs.kitty = {
        enable = true;
        catppuccin = {
          enable = true;
          flavor = config.catppuccin.flavor;
        };
        font = {
          size = 18;
          name = "JetBrains Mono";
          package = pkgs.jetbrains-mono;
        };
        shellIntegration.enableFishIntegration = true;
      };

      programs.fish.shellAliases.ssh = "kitty +kitten ssh";
    };
  };
}
