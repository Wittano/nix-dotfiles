{ config, pkgs, ... }:
with pkgs;
with lib;
let
  draculaOpenbox = fetchFromGitHub {
    owner = "dracula";
    repo = "openbox";
    rev = "b3222509bb291dc62d201a66a1547a7aac0040b3";
    sha256 = "sha256-GZ6/ThHBP3TZshDPHdsNjQEpqowt4eqva0MI/mzELRg=";
  };
  draculaIcon = fetchzip {
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

  config = {
    environment.systemPackages = with pkgs; [ dracula-theme ];

    home-manager.users.wittano = {
      home.file = {
        ".themes/Dracula-withoutBorder".source = builtins.toPath "${draculaOpenbox}/Dracula-withoutBorder";
        ".icons/dracula".source = draculaIcon;
      };
    };
  };
}
