{ pkgs, lib, unstable, secretDir, ... }:
with lib;
with lib.my;
let
  mkAutostartScript = desktopName: cmds:
    assert builtins.all (x: builtins.typeOf x == "string") cmds;
    let
      programs = bash.mkBashArray cmds;
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

  mkDesktopApp = config: dotfiles: name: desktopName: import (./../modules/desktop/submodules + "/${name}.nix") {
    inherit pkgs dotfiles config unstable lib desktopName secretDir;
  };
in
{
  mkDesktopModule =
    { name
    , config
    , isDevMode
    , dotfiles
    , hostname
    , autostart ? [ ]
    , autostartPath ? "autostart.sh"
    , apps ? [ ]
    , mutableSources ? { }
    , extraConfig ? { }
    , enableSessionTarget ? true
    , installAutostartFile ? true
    }:
    let
      cfg = config.modules.desktop.${name};
      self = modules.desktop.${name};

      desktopApps =
        let
          appsList = builtins.map (appName: mkDesktopApp config dotfiles appName name) (apps ++ [ "general" ]);
        in
        builtins.filter
          (app:
            let
              hostOnlyList = app.onlyFor or [ ];
            in
            if builtins.length hostOnlyList > 0
            then builtins.any (n: n == hostname) hostOnlyList
            else true
          )
          appsList;

      desktopAppsModule = mkMerge (builtins.map (x: x.config or { }) desktopApps);

      autostartModule =
        let
          appsAutostart = lists.flatten (builtins.map (x: x.autostart or [ ]) desktopApps);
          cmds = appsAutostart ++ autostart;
        in
        {
          home-manager.users.wittano.xdg.configFile.${autostartPath}.source = mkAutostartScript name cmds;
        };

      mutableSourceFiles =
        let
          mutableAppsSources = lists.foldr
            (next: prev: prev // (next.mutableSources  or { }))
            { }
            desktopApps;
        in
        link.mkMutableLinks {
          inherit config isDevMode;
          paths = mutableAppsSources // mutableSources;
        };

      extraConfigModule =
        if builtins.typeOf extraConfig == "lambda"
        then extraConfig { inherit self cfg isDevMode; }
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
        autostartModule
        mutableSourceFiles
        moduleChecker
        extraConfigModule
        desktopAppsModule
      ];
    in
    {
      options.modules.desktop.${name} = {
        enable = mkEnableOption "Enable ${name} desktop";
      };

      config = mkIf (cfg.enable) (mkMerge modules);
    };
}
