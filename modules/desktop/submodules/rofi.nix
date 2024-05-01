{ pkgs, lib, dotfiles, desktopName, ... }:
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
in
{
  mutableSources = {
    ".config/rofi" = dotfiles.rofi.source;
  };

  config = {
    home-manager.users.wittano.home = {
      packages = with pkgs; [ rofi switchOffScript ];

      file.".local/share/rofi/themes".source = builtins.toPath "${catpuccinTheme}/basic/.local/share/rofi/themes";
    };
  };
}
