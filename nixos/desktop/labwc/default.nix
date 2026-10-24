{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
with lib;
let
  autostartPrograms = map (x: "${x} &") config.home-manager.users.wittano.desktop.autostart.programs;
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
    programs.labwc = {
      enable = true;
      package = unstable.labwc;
    };
    home-manager.users.wittano = {
      desktop.autostart.enable = mkForce false;

      wayland.systemd.target = "labwc-session.target";
      services = {
        wayland-clipboard.enable = true;
        dunst.wittano.enable = mkForce false;
        mako.wittano.enable = true;
        wlsunset.wittano.enable = true;
      };
      programs = {
        screencast.enable = true;
        waypaper.enable = true;
        waybar.wittano = {
          enable = true;
          monitors = [ "HDMI-A-1" ];
        };
        swaylock.enable = true;
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
          "wlr-randr --output HDMI-A-1 --transform normal --pos 1080,0 --preferred --output HDMI-A-2 --right-of HDMI-A-1 --transform 270 --pos 0,0"
        ]
        ++ autostartPrograms;
      };
      xdg.configFile = {
        "labwc/rc.xml".source = ./rc.xml;
        "labwc/menu.xml".source = ./menu.xml;
      };

      home = {
        packages = with pkgs; [
          swaybg
          wlr-randr
          slurp
          grim
          wlrctl
          unstable.labwc-tweaks
          unstable.labwc-menu-generator
          bluetooth-menu-generator
          speedcrunch
        ];
      };
    };

    fonts.packages = [
      pkgs.font-awesome
    ];

    services = {
      displayManager.sddm.wayland.enable = true;
      xserver = {
        enable = mkForce false;
        desktopManager.xfce.waylandSessionCompositor = "labwc --startup";
      };
    };
  };
}
