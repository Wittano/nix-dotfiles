{ pkgs, ... }:
{
  config = rec {
    home-manager.users.wittano = {
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

      programs.fish.shellAliases.ssh = "${home-manager.users.wittano.programs.kitty.package}/bin/kitten ssh";
    };
  };
}
