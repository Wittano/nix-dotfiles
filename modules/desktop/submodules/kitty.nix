{ pkgs, ... }:
let
  catppuccinTheme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "kitty";
    rev = "d7d61716a83cd135344cbb353af9d197c5d7cec1";
    sha256 = "sha256-mRFa+40fuJCUrR1o4zMi7AlgjRtFmii4fNsQyD8hIjM=";
  };
  themeName = "mocha";
in
{
  config = {
    home-manager.users.wittano = {
      programs.kitty = {
        enable = true;
        extraConfig = builtins.readFile (catppuccinTheme + "/themes/${themeName}.conf");
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
