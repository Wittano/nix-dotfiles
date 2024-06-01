{ pkgs, lib, ... }:
with lib;
with lib.my;
let
  catppuccinTheme = pkgs.fetchFromGitHub {
    repo = "Kvantum";
    owner = "catppuccin";
    rev = "04be2ad3d28156cfb62478256f33b58ee27884e9";
    sha256 = "sha256-apOPiVwePXbdKM1/0HAfHzIqAZxvfgL5KHzhoIMXLqI=";
  };

  themes = attrsets.mapAttrs'
    (n: _: {
      name = "Kvantum/${n}";
      value = {
        source = catppuccinTheme + "/src/${n}";
      };
    })
    (builtins.readDir (catppuccinTheme + "/src"));
in
{
  config = {
    qt = {
      enable = true;
      platformTheme = "qt5ct";
      style = "kvantum";
    };

    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ kdePackages.qt6ct libsForQt5.qt5ct ];
        sessionVariables = {
          QT_QPA_PLATFORMTHEME = "qt5ct";
          QT_QPA_PLATFORM = "xcb";
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";
      };

      xdg.configFile = themes // {
        "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
          General.theme = "Catppuccin-Frappe-Sky";
        };
      };
    };

    environment.systemPackages = with pkgs.libsForQt5; [ breeze-icons ];
  };
}
