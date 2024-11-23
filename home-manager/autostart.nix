{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.desktop.autostart;
  mkBashArray = list: builtins.concatStringsSep " " (builtins.map (x: "\"${x}\"") list);
  mkAutostartScript = desktopName: cmds:
    assert builtins.all (x: builtins.typeOf x == "string") cmds;
    let
      programs = mkBashArray cmds;
    in
    pkgs.writeShellScript "autostart.sh" ''
      export DISPLAY=":0"
    
      log_dir=$HOME/.local/share/${desktopName}
      if [ ! -d "$log_dir"  ]; then
        mkdir -p "$log_dir" || exit
      fi
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
  options = {
    desktop.autostart = {
      enable = mkEnableOption "Generate autostart script";
      programs = mkOption {
        type = with types; listOf str;
        description = "List of programs used in autostart script";
        default = [ ];
      };
      desktopName = mkOption {
        type = with types; str;
        description = "List of programs used in autostart script";
      };
      scriptPath = mkOption {
        type = with types; nullOr str;
        description = "Autostart script location. Default path is $HOME/.config/autostart.sh";
        default = null;
      };
    };
  };

  config = {
    home.file = mkIf (cfg.scriptPath != null) {
      "${cfg.scriptPath}".source = mkAutostartScript cfg.desktopName cfg.programs;
    };
    xdg.configFile.${cfg.autostartPath or "autostart.sh"}.source = mkAutostartScript cfg.desktopName cfg.programs;
  };
}
