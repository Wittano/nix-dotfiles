{ config, lib, pkgs, ... }: with lib; let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      slurp
      grim
      wl-clipboard
    ];
    text = "slurp | grim -g - - | wl-copy";
  };
in
{
  options.desktop.labwc = {
    enable = mkEnableOption "labwc";
    users = mkOption {
      description = "List of users that use desktop configuration";
      type = with types; listOf str;
      default = [ "wittano" ];
    };
  };

  config = mkIf config.desktop.labwc.enable {
    programs.labwc.enable = true;
    home-manager.users.wittano = {
      wayland.systemd.target = "labwc-session.target";
      services.wlsunset = {
        enable = true;
        latitude = "50.50";
        longitude = "23.41";
        temperature = {
          day = 6000;
          night = 4300;
        };
      };
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        style = ''
          .active {
            color: @green;
          }
          #custom-music {
            color: @green;
            font-family: "Font Awesome";
          }
          .modules-right * {
            margin: 5px;
          }
        '';
        settings = {
          mainBar = {
            layer = "top";
            output = [ "HDMI-A-1" ];
            position = "top";
            modules-left = [ "ext/workspaces" ];
            modules-center = [ "custom/music" ];
            modules-right = [ "pulseaudio" "clock" "tray" ];
            "ext/workspaces" = {
              disable-scroll = true;
              sort-by-id = true;
              on-click = "activate";
              format = " {icon} ";
              format-icons = {
                default = "";
              };
            };
            tray = {
              icon-size = 21;
              spacing = 10;
            };
            "custom/music" = {
              format = "  {}";
              escape = true;
              interval = 5;
              tooltip = false;
              exec = "${pkgs.playerctl}/bin/playerctl metadata --format='{{ title }}'";
              on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
              max-length = 50;
            };
            clock = {
              timezone = "Europe/Warsaw";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%d/%m/%Y}";
              format = "{:%H:%M}";
            };
            pulseaudio = {
              format = "{icon} {volume}%";
              format-muted = "";
              format-icons = {
                default = [ "" "" " " ];
              };
              on-click = "pavucontrol";
            };
          };
        };
      };

      wayland.windowManager.labwc = {
        enable = true;
        systemd.enable = true;
        xwayland.enable = true;
        environment = [
          "XKB_DEFAULT_LAYOUT=pl"
          "QT_QPA_PLATFORMTHEME=qt6ct"
          "ELECTRON_OZONE_PLATFORM_HINT=auto"
          "_JAVA_AWT_WM_NONREPARENTING=1"
          "PROTON_ENABLE_WAYLAND=1"
          "SDL_VIDEO_DRIVER=wayland"
          "WLR_WL_OUTPUTS=2"
          "RTC_USE_PIPEWIRE=true"
        ];
        autostart = [
          "wlr-randr --output HDMI-A-2 --transform 270 --pos 0,0 --preferred --left-of HDMI-A-1 --output HDMI-A-1 --transform normal &"
          "wl-paste --watch cliphist store &"
          "waypaper --restore &"
        ];
      };
      xdg.configFile = {
        "labwc/rc.xml".source = ./rc.xml;
        "labwc/menu.xml".source = ./menu.xml;
      };

      home = {
        packages = with pkgs; [
          waypaper
          swaybg
          wlr-randr
          slurp
          grim
          wl-clipboard
          screenshot
          wlrctl
          labwc-tweaks
          labwc-menu-generator
        ];
      };
    };

    fonts.packages = [
      pkgs.font-awesome
    ];

    xdg.portal = {
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    services = {
      displayManager.sddm.wayland.enable = true;
      xserver.desktopManager.xfce.waylandSessionCompositor = "labwc --startup";
    };
  };
}
