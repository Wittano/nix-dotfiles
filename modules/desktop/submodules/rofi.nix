{ pkgs, lib, desktopName, ... }:
with lib;
with lib.my;
let
  toybox = pkgs.toybox;
  systemd = pkgs.systemd;

  switchOffScript = pkgs.writeShellApplication {
    name = "switch-off";
    runtimeInputs = with pkgs; [ rofi toybox ];
    text = ''
      SHUTDOWN="Shutdown"
      LOGOUT="Logout"
      REBOOT="Reboot"

      CHOICE=$(printf "%s\n%s\n%s" $SHUTDOWN $LOGOUT $REBOOT | rofi -dmenu)

      case $CHOICE in
      "$SHUTDOWN")
        ${systemd}/bin/poweroff
        ;;
      "$LOGOUT")
        DESKTOP=$(${toybox}/bin/pgrep ${desktopName})
        if [ -n "$DESKTOP" ]; then
          echo "Kill ${desktopName} $DESKTOP"
          kill -9 "$DESKTOP"
        fi 
        ;;
      "$REBOOT")
        ${systemd}/bin/reboot
        ;;
      "*")
        echo "invalid option"
        exit 1
        ;;
      esac
    '';
  };

  catpuccinTheme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    rev = "5350da41a11814f950c3354f090b90d4674a95ce";
    sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
  };
  themeName = "catppuccin-macchiato";
in
{
  config = {
    fonts.packages = with pkgs; [ nerdfonts ];

    home-manager.users.wittano = {
      home.packages = with pkgs; [ switchOffScript oranchelo-icon-theme ];

      programs.rofi = {
        enable = true;
        theme = "${catpuccinTheme}/basic/.local/share/rofi/themes/${themeName}.rasi";
        terminal = meta.getExe pkgs.kitty;
        extraConfig = {
          disable-history = false;
          hide-scrollbar = true;
          show-icons = true;
          icon-theme = "Oranchelo";
          drun-display-format = "{icon} {name}";
          display-drun = " Apps ";
          display-run = " Run ";
          display-window = " Window ";
          display-Network = " Network ";
          sidebar-mode = true;
        };
      };
    };
  };
}