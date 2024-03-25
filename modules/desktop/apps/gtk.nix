{ pkgs, home-manager, lib, cfg, privateRepo, ... }:
with lib;
with lib.my;
let
  colloidIconTheme = pkgs.colloid-icon-theme.override {
    schemeVariants = [ "all" ];
    colorVariants = [ "all" ];
  };
  gtkSettings = {
    "gtk-toolbar-style" = "GTK_TOOLBAR_BOTH_HORIZ";
    "gtk-toolbar-icon-size" = "GTK_ICON_SIZE_LARGE_TOOLBAR";
    "gtk-button-images" = true;
    "gtk-menu-images" = true;
    "gtk-enable-event-sounds" = true;
    "gtk-enable-input-feedback-sounds" = true;
    "gtk-xft-antialias" = true;
    "gtk-xft-hinting" = true;
    "gtk-xft-hintstyle" = "hintslight";
    "gtk-xft-rgba" = "rgb";
    "gtk-modules" = "gail:atk-bridge";
    "gtk-application-prefer-dark-theme" = true;
  };
  catppuccinTheme = pkgs.catppuccin-gtk.override {
    accents = [ "blue" ];
    size = "standard";
    tweaks = [ "normal" ];
    variant = "frappe";
  };
  catppuccinThemeName = "Catppuccin-Frappe-Standard-Blue-Dark";
in
{
  home-manager.users.wittano = {
    home.packages = with pkgs; [ dconf ];
    gtk = {
      enable = true;
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = privateRepo.bibata-cursor-theme;
      };
      font = {
        name = "JetBrains Mono NL";
        size = 12;
        package = pkgs.jetbrains-mono;
      };
      iconTheme = {
        name = "Colloid-dark";
        package = colloidIconTheme;
      };
      theme = {
        name = catppuccinThemeName;
        package = catppuccinTheme;
      };
      gtk3 = {
        extraConfig = gtkSettings;
        bookmarks = [
          "file:///tmp Temporary"
          "file:///home/wittano/Documents"
          "file:///home/wittano/Music"
          "file:///home/wittano/Pictures"
          "file:///home/wittano/Videos"
          "file:///home/wittano/Downloads"
          "file:///mnt/backup Backup"
          "file:///home/wittano/projects Projects"
          "file:///home/wittano/.config User config"
          "file:///mnt/raspberry Raspberry - shared folder"
        ];
      };
      gtk4.extraConfig = gtkSettings;
    };

    xdg.configFile = {
      "gtk-4.0/assets".source = "${catppuccinTheme}/share/themes/${catppuccinThemeName}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${catppuccinTheme}/share/themes/${catppuccinThemeName}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${catppuccinTheme}/share/themes/${catppuccinThemeName}/gtk-4.0/gtk-dark.css";
    };
  };
}
