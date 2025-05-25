{ config, pkgs, lib, ... }:
with lib;
with lib.my;
{
  options.qt.wittano.enable = mkEnableOption "Enable custom QT configuration";

  config = mkIf config.qt.wittano.enable {
    home = {
      packages = with pkgs; [ kdePackages.qt6ct libsForQt5.qt5ct libsForQt5.breeze-icons ];
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "kvantum";
        QT_QPA_PLATFORM = "xcb";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };
  };

}
