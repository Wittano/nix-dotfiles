{ pkgs, lib, dotfiles, ... }:
with lib;
with lib.my;
let
  desktopAppsDir = ./../modules/desktop/apps;
  desktopAppNames = string.mkNixNamesFromDir desktopAppNames;

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

  mkDesktopApp = config: cfg: appName: desktopName:
    let
      name = string.removeSuffix ".nix" appName;
    in
    import (desktopAppsDir + "/${name}.nix") {
      inherit cfg pkgs dotfiles config lib desktopName;
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

      source =
        let
          autostartMerge = cfg.autostartPrograms ++ autostart;
        in
        if builtins.length autostartMerge > 0
        then mutableSources // { "${autostartPath}" = mkAutostartScript name autostartMerge; }
        else mutableSources;
      mutableSourceFiles =
        let
          additionalSources = attrsets.optionalAttrs (cfg ? mutableSources) cfg.mutableSources;
        in
        link.mkMutableLinks {
          inherit config isDevMode;
          paths = (source // additionalSources);
        };

      apps = builtins.map (appName: mkDesktopApp config cfg appName name) desktopApps;

      extraConfigModule =
        if builtins.typeOf extraConfig == "lambda"
        then
          extraConfig
            {
              inherit self cfg isDevMode;
              autostartScript = strings.concatStringsSep "\n" (builtins.attrValues source);
            }
        else extraConfig;

      # TODO Change module checker for module config 
      moduleChecker = {
        assertions = [
          {
            assertion = builtins.typeOf extraConfigModule == "set";
            message = "extraConfigFunc must return set of configuration";
          }
          {
            assertion = builtins.all (x: builtins.pathExists (desktopAppsDir + "/${x}.nix")) desktopApps;
            message =
              let
                msg = builtins.concatStringsSep ", " desktopAppNames;
              in
              "One of desktop apps doesn't exist. There are avaiable apps: [${msg}]";
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
