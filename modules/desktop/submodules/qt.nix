{ pkgs, lib, ... }:
with lib;
with lib.my;
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
        style = {
          name = "kvantum";
          catppuccin = {
            enable = true;
            accent = "sky";
            flavor = "frappe";
          };
        };
      };
    };

    environment.systemPackages = with pkgs.libsForQt5; [ breeze-icons ];
  };
}
