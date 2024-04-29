{ pkgs, lib, dotfiles, ... }:
with lib;
with lib.my;
let
  desktopAppsDir = ./../modules/desktop/apps;

  mkAutostartScript = desktopName: cmds:
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

  mkDesktopApp = config: appName: desktopName: import (desktopAppsDir + "/${appName}.nix") {
    inherit pkgs dotfiles config lib desktopName;
  };
in
{
  mkDesktopModule =
    { name
    , config
    , isDevMode
    , autostart ? [ ]
    , autostartPath ? ".config/${name}/autostart.sh"
    , desktopApps ? [ ]
    , mutableSources ? { }
    , extraConfig ? { }
    }:
    let
      cfg = config.modules.desktop.${name};
      self = modules.desktop.${name};

      autostartMerge = cfg.autostartPrograms ++ autostart;
      autostartScript = mkAutostartScript name autostartMerge;

      source =
        if builtins.length autostartMerge > 0
        then mutableSources // { "${autostartPath}" = autostartScript; }
        else mutableSources;
      mutableSourceFiles = link.mkMutableLinks {
        inherit config isDevMode;
        paths = (source // cfg.mutableSources);
      };

      apps = builtins.map (appName: mkDesktopApp config appName name) desktopApps;

      extraConfigModule =
        if builtins.typeOf extraConfig == "lambda"
        then
          extraConfig
            {
              inherit self cfg isDevMode;
              autostartScript = builtins.readFile autostartScript;
            }
        else extraConfig;

      moduleChecker = {
        assertions = [
          {
            assertion = builtins.typeOf extraConfigModule == "set";
            message = "extraConfigFunc must return set of configuration";
          }
        ];
      };

      modules = [
        mutableSourceFiles
        moduleChecker
        extraConfigModule
      ] ++ apps;
    in
    {
      options.modules.desktop.${name} = {
        enable = mkEnableOption "Enable ${name} desktop";
        autostartPrograms = mkOption {
          type = types.listOf types.str;
          example = [ "${pkgs.hello}/bin/hello --special-args" ];
          default = [ ];
          description = "list of programs, that should start on startup";
        };
        mutableSources = mkOption {
          type = types.attrs;
          description = "Set of additional sources, which should be include to desktop as mutable links";
          example = {
            "/path/to/file" = ./test.txt;
            "/path/to/string" = "my string";
          };
          default = { };
        };
      };

      config = mkIf (cfg.enable) (mkMerge modules);
    };
}
