{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.waybar.wittano;
in
{
  options.programs.waybar.wittano = {
    enable = mkEnableOption "waybar";
    monitors = mkOption {
      type = types.listOf types.str;
      description = "list of monitors to display waybar";
    };
    mode = mkOption {
      type = types.enum [
        "pc"
        "laptop"
      ];
      description = "Enable additional features per laptop or pc e.g. battery status";
      default = "pc";
    };
  };

  config = {
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
          output = cfg.monitors;
          position = "top";
          modules-left = [ "ext/workspaces" ];
          modules-center = [ "custom/music" ];
          modules-right =
            if config.programs.waybar.wittano.mode == "laptop" then
              [
                "pulseaudio"
                "battery"
                "clock"
                "tray"
              ]
            else
              [
                "pulseaudio"
                "clock"
                "tray"
              ];
          "mango/workspaces" = {
            format = "{icon}";
            hide-empty = true;
            on-click = "activate";
            on-click-right = "toggle";
            overview-label = "OVERVIEW";
          };
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
              default = [
                ""
                ""
                " "
              ];
            };
            on-click = "pavucontrol";
          };
          battery = {
            bat = "BAT1";
            interval = 30;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            max-lenght = 25;
          };
        };
      };
    };
  };
}
