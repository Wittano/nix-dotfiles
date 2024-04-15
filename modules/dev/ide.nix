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

  ideNames = builtins.attrNames avaiableIde;

  installedIDEs = builtins.map (x: avaiableIde."${x}".package) cfg.list;

  mkCommand = path: {
    body = /*fish*/ ''
      set -l args_len $(count $argv)

      if test "$args_len" -eq 0
        cd ${path}
      else
        cd ${path}/$argv
      end
    '';
  };

  mkCompletions = name: path: ''
    function get_projects_dir
      ls ${path}
    end

    for project in (get_projects_dir)
      complete -c ${name} -f -a "$project"
    end
  '';

  cmdCompletions = builtins.map
    (x:
      let
        path = avaiableIde."${x}".projectDir;
      in
      rec {
        name = "p${x}";
        value = mkCompletions name path;
      })
    cfg.list;

  commands = builtins.listToAttrs (builtins.map
    (x:
      let
        path = avaiableIde."${x}".projectDir;
      in
      {
        name = "p${x}";
        value = mkCommand path;
      })
    cfg.list);

  forkCommand.pfork = mkCommand "$HOME/projects/own/fork";
  forkCompletions = [
    rec {
      name = "pfork";
      value = mkCompletions name "$HOME/projects/own/fork";
    }
  ];
in
{
  options = {
    modules.dev.ide = {
      list = mkOption {
        type = types.listOf (types.enum ideNames);
        description = "List of enabled IDEs";
        default = [ ];
      };
    };
  };

  config = mkIf ((builtins.length cfg.list) != 0) {
    modules.shell.fish.completions = cmdCompletions ++ forkCompletions;

    home-manager.users.wittano = {
      home.packages = installedIDEs;

      programs.fish.functions = commands // forkCommand;
    };
  };
}

