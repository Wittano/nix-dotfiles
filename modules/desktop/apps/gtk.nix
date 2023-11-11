{ pkgs, home-manager, lib, cfg, ... }:
with lib;
with lib.my;
let
  colloidIconTheme = pkgs.colloid-icon-theme.override {
    schemeVariants = [ "all" ];
    colorVariants = [ "all" ];
  };
in
{
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ lxappearance libsForQt5.breeze-qt5 colloidIconTheme ];
      activation.linkMutableKittyConfig =
        link.createMutableLinkActivation {
          internalPath = ".config/gtk-3.0/settings.ini";
          isDevMode = cfg.enableDevMode;
        };
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      "gtk-3.0/settings.ini".source = builtins.toFile "settings.ini" ''
        [Settings]
        gtk-icon-theme-name=Colloid-dark
        gtk-theme-name=Catppuccin-Frappe-Standard-Blue-Dark
        gtk-font-name=JetBrains Mono NL 12
        gtk-cursor-theme-name=Breeze_Snow
        gtk-cursor-theme-size=0
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
        gtk-modules=gail:atk-bridge
      '';
    };
  };
}
