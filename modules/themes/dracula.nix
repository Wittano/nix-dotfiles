{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
  # TODO Migrate theme to GTK app or Openbox configuration
  cfg = config.modules.themes.dracula;
  draculaOpenbox = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "openbox";
    rev = "b3222509bb291dc62d201a66a1547a7aac0040b3";
    sha256 = "sha256-GZ6/ThHBP3TZshDPHdsNjQEpqowt4eqva0MI/mzELRg=";
  };
  draculaIcon = pkgs.fetchzip {
    url = "https://github.com/dracula/gtk/files/5214870/Dracula.zip";
    sha256 = "sha256-rcSKlgI3bxdh4INdebijKElqbmAfTwO+oEt6M2D1ls0=";
  };
in
{
  options = {
    modules.themes.dracula = {
      enable = mkEnableOption ''
        Enable dracula theme as system theme
      '';
    };
  };

  config = mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [ dracula-theme ];

    home-manager.users.wittano.home.file = {
      ".themes/Dracula-withoutBorder".source =
        builtins.toPath "${draculaOpenbox}/Dracula-withoutBorder";

      ".icons/dracula".source = draculaIcon;
    };
  };
}
