{ pkgs, lib, ... }: {
  mkAutostartOption = desktopName: {
    autostartPrograms = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = [ "${pkgs.hello}/bin/hello --special-args" ];
      default = [ ];
      description = "list of programs, that should start on ${desktopName} startup";
    };
  };

  mkAutostart = desktopName: cmds:
    assert builtins.all (x: builtins.typeOf x == "string") cmds;
    let
      programs = builtins.concatStringsSep "\n" (builtins.map (x: ''"${x}"'') cmds);
    in
    pkgs.writeShellScript "autostart.sh" ''
      export DISPLAY=":0"
    
      log_dir=$HOME/.local/share/${desktopName}

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
}
