{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.rofi.wittano;
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
        DESKTOP=$(${toybox}/bin/pgrep ${cfg.desktopName})
        if [ -n "$DESKTOP" ]; then
          echo "Kill ${cfg.desktopName} $DESKTOP"
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
in
{
  options.programs.rofi.wittano = {
    enable = mkEnableOption "Enable custom rofi config";
    desktopName = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages =
      let
        script =
          if cfg.desktopName != null
          then [ switchOffScript ]
          else [ ];
      in
      with pkgs; [ nerdfonts oranchelo-icon-theme ] ++ script;

    programs.rofi = {
      enable = true;
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
}
