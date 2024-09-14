{ config, pkgs, lib, isDevMode, hostname, dotfiles, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode hostname dotfiles;

  name = "bspwm";
  apps = [
    "nitrogen"
    "picom"
    "gtk"
    "kitty"
    "tmux"
    "bluetooth"
    "dunst"
    "rofi"
    "polybar"
    "feh"
  ];
  installAutostartFile = false;
  autostart = [ "wmname compiz" ];
  extraConfig = ({ cfg, isDevMode, ... }:
    let
      package = pkgs.bspwm;
    in
    {
      home-manager.users.wittano = {
        home.packages = with pkgs; [ gsimplecal ];

        xsession.windowManager.bspwm = {
          inherit package;

          enable = true;

          alwaysResetDesktops = isDevMode;
          monitors = {
            "DVI-D-0" = [ "I" "II" "III" ];
            "HDMI-0" = [ "IV" "V" ];
          };
          settings = {
            "border_width" = 2;
            "window_gap" = 20;
            "normal_border_color" = "#212337";
            "focused_border_color" = "#86E1FC";
            "split_ratio" = 0.52;
            "borderless_monocle" = true;
            "gapless_monocle" = true;
          };

          rules =
            let
              DEV_WORKSPACE = "^1";
              WEB_BROWSER_WORKSPACE = "^2";
              TERMINAL_WORKSPACE = "^3";
              MUSIC_WORKSPACE = "^4";
              DISCORD_WORKSPACE = "^5";
            in
            {
              # Dev tools
              "jetbrains-*".desktop = DEV_WORKSPACE;

              "Emacs" = {
                desktop = DEV_WORKSPACE;
                state = "fullscreen";
              };
              "Code".desktop = DEV_WORKSPACE;

              # Web browsers
              "Chromium".desktop = WEB_BROWSER_WORKSPACE;
              "qutebrowser".desktop = WEB_BROWSER_WORKSPACE;
              "Vivaldi-stable".desktop = WEB_BROWSER_WORKSPACE;
              "Firefox".desktop = WEB_BROWSER_WORKSPACE;
              "Firefox-esr".desktop = WEB_BROWSER_WORKSPACE;
              "Tor Browser".desktop = WEB_BROWSER_WORKSPACE;

              # Utils
              thunderbird.desktop = "^2";
              Thunderbird.desktop = "^2";

              # Music
              "Rhythmbox".desktop = MUSIC_WORKSPACE;
              "Spotify".desktop = MUSIC_WORKSPACE;

              # Terminals
              "Terminator".desktop = TERMINAL_WORKSPACE;
              "kitty".desktop = TERMINAL_WORKSPACE;
              "Alacritty".desktop = TERMINAL_WORKSPACE;

              # Media
              discord.desktop = DISCORD_WORKSPACE;

              # Games
              "openttd".desktop = "^1";
              "Steam".desktop = "^1";
              "lutris".desktop = "^1";
              "genshinimpact.exe".desktop = "^1";
              "steam_app_39540" = {
                desktop = "^1";
                state = "fullscreen";
              };
              "Paradox Launcher".desktop = "^1";
              "Cities.x64".desktop = "^1";
              "steam_app_813780".desktop = "^1";
              "mb_warband_linux".desktop = "^1";
              "hl2_linux".desktop = "^1";
              "minecraft-launcher".desktop = "^1";
              "Shogun2".desktop = "^1";
            };
        };

        services.sxhkd = {
          enable = true;
          keybindings = {
            # Terminal
            "super + Return" = "kitty";

            # Rofi
            "super + e" = "rofi -show drun";
            "super + w" = "rofi -show window";
            "super + shift + q" = "switch-off";

            # Audio
            "super + m" = "amixer sset Master toggle";
            "super + p" = "amixer sset Master 5%+";
            "super + o" = "amixer sset Master 5%-";

            # Utilites
            "super + shift + p" = "flameshot gui";
            "super + r" = "rollWallpaper";

            # bspwm hotkeys
            "super + alt + r" = "bspc wm -r";
            "super + {_,shift + }q" = "bspc node -{c,k}";
            "super + Tab" = "bspc desktop -l next";
            "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
            "super + space" = "bspc node -s biggest";

            # state/flags
            "super + {t,shift + t,s,f}" = "bspc node -t {tiled ,pseudo_tiled ,floating ,fullscreen }";

            # focus/swap
            "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
            "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
            "super + {grave,Tab}" = "bspc {node,desktop} -f last";
            "super + {_,shift + }{1-5,6-0}" = "bspc {desktop -f,node -d} '^{1-5,1-5}'";

            # move/resize
            "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
            "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
            "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
          };
        };
      };

      services.xserver = {
        enable = true;
        windowManager.bspwm = {
          inherit package;

          enable = true;
        };
      };
    });
}
