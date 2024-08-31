{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  colloidSchemaVariant = "dracula";
  colloidIconTheme = pkgs.colloid-icon-theme.override {
    schemeVariants = [ colloidSchemaVariant ];
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
    accents = [ "blue" ];
    size = "standard";
    tweaks = [ "normal" ];
    variant = "frappe";
  };
  catppuccinThemeName = "catppuccin-frappe-blue-standard+normal";
  cursorTheme = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
  };
in
{
  config = {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [ dconf ];
        pointerCursor = {
          size = 22;
          x11 = {
            enable = true;
            defaultCursor = cursorTheme.name;
          };
          gtk.enable = true;
        } // cursorTheme;
      };

      i18n.inputMethod.fcitx5.catppuccin = {
        enable = true;
        flavor = "frappe";
      };
      gtk = {
        inherit cursorTheme;

        enable = true;
        font = {
          name = "JetBrains Mono NL";
          size = 12;
          package = pkgs.jetbrains-mono;
        };
        iconTheme = {
          name = "Colloid-${colloidSchemaVariant}-dark";
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
            "file:///home/wittano/.config Config files"
            "file://${config.environment.variables.NIX_DOTFILES} Nix configuration"
            "file://${config.environment.variables.NIX_DOTFILES}/dotfiles Dotfiles"
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
  };
}
