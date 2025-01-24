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

  autostartScript = mkAutostartScript "desktop" cfg.programs;
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
      paths = mkOption {
        type = with types; listOf (nullOr str);
        description = "List of locations of autostart script location. Default path is $HOME/.config/autostart.sh";
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable {
    home.file = trivial.pipe cfg.paths [
      (builtins.filter (x: x != null && x != ""))
      (builtins.map (x: {
        name = x;
        value = {
          source = autostartScript;
        };
      }))
      builtins.listToAttrs
    ];
    xdg.configFile =
      if (cfg.paths != [ ]) then
        trivial.pipe cfg.paths [
          (builtins.filter (x: x == null || x == ""))
          (builtins.map (x: {
            name = x;
            value = {
              source = autostartScript;
            };
          }))
          builtins.listToAttrs
        ] else {
        "autostart.sh".source = autostartScript;
      };
  };
}
