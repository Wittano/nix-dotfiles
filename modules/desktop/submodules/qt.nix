{ config, pkgs, lib, ... }:
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
          QT_QPA_PLATFORMTHEME = "kvantum";
          QT_QPA_PLATFORM = "xcb";
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style = {
          name = "kvantum";
          catppuccin = {
            enable = true;
            flavor = config.catppuccin.flavor;
            accent = config.catppuccin.accent;
          };
        };
      };
    };

    environment.systemPackages = with pkgs.libsForQt5; [ breeze-icons ];
  };
}
