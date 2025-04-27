{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  homeDir = config.home.homeDirectory;

  colloidSchemaVariant = "Dracula";
  colloidIconTheme = pkgs.colloid-icon-theme.override {
    schemeVariants = [ (strings.toLower colloidSchemaVariant) ];
    colorVariants = [ "default" ];
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
    accents = [ config.catppuccin.accent ];
    size = "standard";
    tweaks = [ "normal" ];
    variant = config.catppuccin.flavor;
  };
  catppuccinThemeName = "catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}-standard+normal";
  cursorTheme = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
  };
in
{
  options.gtk.wittano.enable = mkEnableOption "Enable custom config for GTK";

  config = mkIf config.gtk.wittano.enable {
    home = {
      packages = [ pkgs.dconf ];
      pointerCursor = {
        size = 22;
        x11 = {
          enable = true;
          defaultCursor = cursorTheme.name;
        };
        gtk.enable = true;
      } // cursorTheme;
    };

    catppuccin.fcitx5 = {
      inherit (catppuccin) flavor;

      enable = true;
    };
    gtk = {
      inherit cursorTheme;

      enable = true;
      font = {
        name = "JetBrains Mono NL";
        size = 12;
        package = pkgs.jetbrains-mono;
      };
      iconTheme =
        let
          lightness = if config.catppuccin.flavor == "latte" then "Light" else "Dark";
        in
        {
          name = "Colloid-${colloidSchemaVariant}-${lightness}";
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
          "file://${homeDir}/Documents"
          "file://${homeDir}/Music"
          "file://${homeDir}/Pictures"
          "file://${homeDir}/Videos"
          "file://${homeDir}/Downloads"
          "file://${homeDir}/.config Config files"
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
