{ pkgs, lib, dotfiles, home-manager, privateRepo, unstable, ... }:
with lib;
with lib.my;
rec {
  mkAutostartOption = {
    autostartPrograms = mkOption {
      type = types.listOf types.str;
      example = [ "${pkgs.hello}/bin/hello --special-args" ];
      default = [ ];
      description = "list of programs, that should start on startup";
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

  mkDevMode = config: cfg: pathAttrs: {
    options = {
      enableDevMode = mkEnableOption "Enable dev mode";
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

    config =
      let
        additionalSources = attrsets.optionalAttrs (cfg ? mutableSources) cfg.mutableSources;
      in
      link.mkMutableLinks config cfg (pathAttrs // additionalSources);
  };

  mkAppsSet = { config, cfg, name ? "qtile" }:
    let
      sourceDir = ./../modules/desktop/apps;
      appFiles = lib.attrsets.filterAttrs
        (n: v: ((lib.strings.hasSuffix ".nix" n) && v == "regular"))
        (builtins.readDir sourceDir);
    in
    lib.attrsets.mapAttrs'
      (n: v: {
        name = builtins.replaceStrings [ ".nix" ] [ "" ] n;
        value = import "${sourceDir}/${n}" {
          inherit cfg privateRepo pkgs dotfiles home-manager unstable config lib name;
        };
      })
      appFiles;

  mkDesktopOption = { devMode ? null }:
    let
      devModeOptions = attrsets.optionalAttrs (devMode != null && devMode ? options) devMode.options;
      autoStartOptions = mkAutostartOption;
    in
    {
      enable = mkEnableOption "Enable desktop";
    } // devModeOptions // autoStartOptions;
}
