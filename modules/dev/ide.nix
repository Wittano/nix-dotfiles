{ config, pkgs, home-manager, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.ide;

  avaiableIde = {
    python = {
      package = pkgs.jetbrains.pycharm-professional;
      projectDir = "$HOME/projects/own/python";
    };
    cpp = {
      package = pkgs.jetbrains.clion;
      projectDir = "$HOME/projects/own/cpp";
    };
    go = {
      package = pkgs.jetbrains.goland;
      projectDir = "$HOME/projects/own/go";
    };
    dotnet = {
      package = pkgs.jetbrains.rider;
      projectDir = "$HOME/projects/own/dotnet";
    };
    rust = {
      package = pkgs.jetbrains.rust-rover;
      projectDir = "$HOME/projects/own/rust";
    };
    jvm = {
      package = pkgs.jetbrains.idea-ultimate;
      projectDir = "$HOME/projects/own/jvm";
    };
    andorid = {
      package = pkgs.andorid-studio;
      projectDir = "$HOME/projects/own/andorid";
    };
  };

  installedIDEs = builtins.map (x: avaiableIde."${x}".package) cfg.list;

  cmdCompletions = builtins.listToAttrs (builtins.map
    (x:
      let
        path = avaiableIde."${x}".projectDir;
        commandName = "p${x}";
      in
      {
        name = "fish/completions/${commandName}.fish";
        value = {
          text = /*fish*/ ''
            function get_projects_dir
              ls ${path}
            end

            for project in (get_projects_dir)
              complete -c ${commandName} -f -a "$project"
            end
          '';
        };
      })
    cfg.list);

  commands = builtins.listToAttrs (builtins.map
    (x:
      let
        path = avaiableIde."${x}".projectDir;
        commandName = "p${x}";
      in
      {
        name = commandName;
        value = {
          body = /*fish*/ ''
            set -l args_len $(count $argv)

            if test "$args_len" -eq 0
              cd ${path}
            else
              cd ${path}/$argv
            end
          '';
        };
      })
    cfg.list);
in
{
  options = {
    modules.dev.ide = {
      list = mkOption {
        type = types.listOf types.str;
        description = "List of enabled IDEs";
        default = [ ];
      };
    };
  };

  config = mkIf ((builtins.length cfg.list) != 0) {
    home-manager.users.wittano = {
      home.packages = installedIDEs;
      xdg.configFile = cmdCompletions;

      programs.fish.functions = commands;
    };
  };
}

