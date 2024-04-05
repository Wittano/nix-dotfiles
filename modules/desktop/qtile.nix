{ config, pkgs, lib, dotfiles, privateRepo, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.qtile;
  desktopApps = apps.desktopApps config cfg;
  programs = builtins.concatStringsSep "\n" (builtins.map (x: ''"${x}"'') cfg.autostartPrograms);
  autostartScript = pkgs.writeShellScript "autostart.sh" ''
    export DISPLAY=":0"
    
    log_dir=$HOME/.local/share/qtile

    _log_app() {
      exec_path=$(echo "$1" | awk '{ print $1 }')
      app_name=$(basename "$exec_path")
      time=$(date +"%D %T")

      echo "[autostart] $time: Launch $app_name"
      ${pkgs.bash}/bin/bash -c "$1" 2>"$log_dir/$app_name.log" || echo "[warning] $" &
    }

    declare -a programs

    programs=(${programs})

    IFS=""

    for app in ''${programs[*]}; do
      _log_app "$app"
    done
  '';
in
{
  options.modules.desktop.qtile = {
    enable = mkEnableOption "Enable Qtile desktop";
    autostartPrograms = mkOption {
      type = types.listOf types.str;
      example = [ "${pkgs.hello}/bin/hello --special-args" ];
      default = [ ];
      description = "list of programs, that should start on QTILE startup";
    };
  };

  config = mkIf (cfg.enable) (mkMerge (with desktopApps; [
    feh
    gtk
    qt
    dunst
    picom
    tmux
    kitty
    rofi
    {
      home-manager.users.wittano = {
        home.activation.linkMutableQtileConfig = link.createMutableLinkActivation cfg "qtile";

        xdg.configFile = {
          qtile.source = dotfiles.qtile.source;
          "autostart.sh".source = autostartScript;
        };
      };

      services.xserver = {
        enable = true;
        windowManager.qtile.enable = true;
      };
    }
  ]));
}
