{ pkgs, home-manager, lib, cfg, privateRepo, ... }:
with lib;
with lib.my;
let
  theme = pkgs.catppuccin-kvantum;
  themeName = "Catppuccin-Frappe-Blue";
in
{
  home-manager.users.wittano = {
    xdg.configFile."Kvantum/${themeName}".source = "${theme}/share/Kvantum/${themeName}";
    xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=${themeName}
    '';

    home.packages = with pkgs.libsForQt5; [ breeze-icons ];

    qt = {
      enable = true;
      platformTheme = "qtct";
      style.name = "kvantum";
    };
  };
}
