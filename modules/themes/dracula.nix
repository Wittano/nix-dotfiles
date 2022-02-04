{ config, pkgs, ... }:
with pkgs;
with lib;
let
  draculaGTK = fetchFromGitHub {
    owner = "dracula";
    repo = "gtk";
    rev = "18bb561588866e71ed2ef5176c2e4797c58f2655";
    sha256 = "sha256-Rhq0c9cbKaQkLqUt2kjyE2S1imPF+W0vyU/giOXLeMQ=";
  };
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
in {
  options = {
    modules.themes.dracula = {
      enable = mkEnableOption ''
        Enable dracula theme as system theme
      '';
    };
  };

  config = {
    home-manager.users.wittano = {
      home.file = {
        ".themes/dracula-gtk".source = draculaGTK;
        ".themes/dracula-openbox".source = draculaOpenbox;
        ".icons/dracula".source = draculaIcon;
      };
    };
  };
}
