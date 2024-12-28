{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  colors = {
    background = "#212337";
    background-alt = "#444";
    foreground = "#c8d3f5";
    foreground-alt = "#555";
    selected = "#C3E88D";
    selectedW = "#86e1fc";
    visibleW = "#b1e16a";
    titleApp = "#55cc80";
    border = "#212337";
    kernel = "#ff995e";
    cpu = "#ff98a4";
    wifi = "#c3e88d";
    date = "#50c4fa";
    volume = "#677CE4";
    space = "#CC75BC";
    emptyW = "#555";
  };
in
{
  options.serivces.polybar.wittano.enable = mkEnableOption "Enable custom polybar config";

  config = mkIf config.serivces.polybar.wittano.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [ font-awesome font-awesome_5 siji nerdfonts ];

    services.polybar = {
      enable = true;
      script = "polybar wittano";
      config = {
        "bar/wittano" = {
          monitor = "\${env:MONITOR:DVI-D-0}";
          width = "100%";
          height = 27;
          radius = 6;
          fixed-center = false;

          inherit (colors) background foreground;

          line-size = 3;
          line-color = "#f00";

          padding-left = 0;
          padding-right = 2;

          module-margin-left = 1;
          module-margin-right = 2;

          font-0 = "DejaVuSans:pixelsize=10:style=Regular";
          font-1 = "fixed:pixelsize=10;1";
          font-2 = "unifont:fontformat=truetype:size=8:antialias=false;0";
          font-3 = "siji:pixelsize=10;1";
          font-4 = "all-the-icons:pixelsize=10";
          font-5 = "Font Awesome 5 Brands:pixelsize=10";
          font-6 = "Font Awesome 5 Free:style=Solid:pixelsize=10";

          modules-left = [ "logo" "bspwm" "xwindow" ];
          modules-right = [ "kernel" "sep" "filesystem" "sep" "alsa" "sep" "memory" "sep" "cpu" "sep" "wlan" "sep" "date" ];

          tray-position = "right";
          tray-padding = 2;

          wm-restack = "bspwm";

          scroll-up = "bspwm-desknext";
          scroll-down = "bspwm-deskprev";
        };
        "bar/laptop" = {
          monitor = "\${env:MONITOR}";
          width = "100%";
          height = 27;
          radius = 6;
          fixed-center = false;

          inherit (colors) background foreground;

          line-size = 3;
          line-color = "#f00";

          padding-left = 0;
          padding-right = 2;

          module-margin-left = 1;
          module-margin-right = 2;

          font-0 = "fixed:pixelsize=10;1";
          font-1 = "unifont:fontformat=truetype:size=8:antialias=false;0";
          font-2 = "siji:pixelsize=10;1";
          font-3 = "all-the-icons:pixelsize=10";
          font-4 = "Font Awesome 5 Brands:pixelsize=10";
          font-5 = "Font Awesome 5 Free:style=Solid:pixelsize=10";

          modules-left = [ "logo" "bspwm" "xwindow" ];
          modules-right = [ "kernel" "sep" "filesystem" "sep" "alsa" "sep" "memory" "sep" "cpu" "sep" "wifi-laptop" "sep" "battery" "sep" "date" ];

          tray-position = "right";
          tray-padding = 2;

          wm-restack = "bspwm";

          scroll-up = "bspwm-desknext";
          scroll-down = "bspwm-deskprev";
        };
      };
      settings = {
        "global/wm" = {
          margin-top = 0;
          margin-bottom = 0;
        };
        "module/logo" = {
          type = "custom/script";
          exec = "echo ' '";
        };
        "module/sep" = {
          type = "custom/script";
          exec = "echo ' | '";
        };
        "module/kernel" = {
          type = "custom/script";
          exec = "${pkgs.toybox}/bin/uname -rs";
          label = " %output%";
          format-foreground = colors.kernel;
        };
        "module/xwindow" = {
          type = "internal/xwindow";
          label = "%title:0:30:...%";
          label-foreground = colors.titleApp;
        };
        "module/filesystem" = {
          type = "internal/fs";
          interval = 25;
          mount-0 = "/";
          label-mounted = ": %free%";
          label-unmounted = "%mountpoint% not mounted";
          label-mounted-foreground = colors.space;
        };
        "module/bspwm" = {
          type = "internal/bspwm";
          pin-workspaces = true;

          label-focused = "[ %name% ]";
          label-focused-foreground = colors.selectedW;
          label-focused-padding = 2;

          label-occupied = "%name%";
          label-occupied-foreground = colors.visibleW;
          label-occupied-padding = 2;

          label-urgent = "%name%!";
          label-urgent-foreground = colors.visibleW;
          label-urgent-padding = 2;

          label-empty = "%name%";
          label-empty-foreground = colors.emptyW;
          label-empty-padding = 2;
          label-separator = "|";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = " CPU: ";
          format-foreground = colors.cpu;
          format-prefix-foreground = colors.cpu;
          label = "%percentage:2%%";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = 2;
          format-prefix = " Mem: ";
          label = "%gb_used%";
        };
        "module/wlan" = {
          type = "internal/network";
          interface = "eno1";
          interval = 3;

          format-connected = "<ramp-signal> <label-connected>";
          format-foreground = colors.wifi;
          label-connected = " %upspeed%  %downspeed%";
          label-connected-foreground = colors.wifi;

          format-disconnected = "None";
          format-disconnected-foreground = colors.wifi;

          ramp-signal-0 = "";
        };
        "module/wifi-laptop" = {
          type = "internal/network";
          interface = "wlp3s0";
          interval = 3;

          format-connected = "<ramp-signal> <label-connected>";
          format-foreground = colors.wifi;
          label-connected = " %upspeed%  %downspeed%";
          label-connected-foreground = colors.wifi;

          format-disconnected = "None";
          format-disconnected-foreground = colors.wifi;
        };
        "module/date" = {
          type = "internal/date";
          interval = 5;

          date = "%d %b %Y";
          time = "%H:%M";

          format = "<label>";
          format-prefix = " ";
          format-foreground = colors.date;

          label = "%date% - (%time%)";
        };
        "module/alsa" = {
          type = "internal/alsa";

          format-volume = "<label-volume>";
          label-volume = " %percentage%%";
          label-volume-foreground = colors.volume;
          label-muted = "muted";
          label-muted-foreground = "#666";
          bar-volume-width = 10;
          bar-volume-foreground-0 = "#55aa55";
          bar-volume-foreground-1 = "#55aa55";
          bar-volume-foreground-2 = "#55aa55";
          bar-volume-foreground-3 = "#55aa55";
          bar-volume-foreground-4 = "#55aa55";
          bar-volume-foreground-5 = "#f5a70a";
          bar-volume-foreground-6 = "#ff5555";
          bar-volume-gradient = false;
          bar-volume-indicator = "|";
          bar-volume-indicator-font = 2;
          bar-volume-fill = "─";
          bar-volume-fill-font = 2;
          bar-volume-empty = "─";
          bar-volume-empty-font = 2;
          bar-volume-empty-foreground = colors.foreground-alt;
        };
        "module/battery" = {
          type = "internal/battery";

          full-at = 99;
          battery = "BAT1";
          adapter = "ACAD";
          poll-interval = 5;

          format-discharging = "<ramp-capacity> <label-discharging>";

          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          ramp-capacity-3 = "";
          ramp-capacity-4 = "";

          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-3 = "";
          animation-charging-4 = "";
          animation-charging-framerate = 750;

          animation-discharging-0 = "";
          animation-discharging-1 = "";
          animation-discharging-2 = "";
          animation-discharging-3 = "";
          animation-discharging-4 = "";
          animation-discharging-framerate = 500;

          bar-capacity-width = 10;
        };
      };
    };
  };
}

