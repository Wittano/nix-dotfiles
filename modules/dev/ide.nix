{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.ide;

  addProjectDirField = attr: builtins.mapAttrs (n: v: v // { projectDir = "${config.home-manager.users.wittano.home.homeDirectory}/projects/own/${n}"; }) attr;

  avaiableIde = addProjectDirField (with pkgs.jetbrains; {
    python.package = pycharm-professional;
    cpp.package = clion;
    go.package = goland;
    dotnet.package = rider;
    rust.package = rust-rover;
    jvm.package = idea-ultimate;
    andorid.package = pkgs.andorid-studio;
  });

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
      home = {
        packages = installedIDEs;
        activation = {
          createProjectsDir =
            let
              projectDirs = builtins.map (x: avaiableIde.${x}.projectDir) cfg.list;
              bashArray = builtins.concatStringsSep " " (builtins.map (x: "'${x}'") projectDirs);
            in
            lib.hm.dag.entryBefore [ "writeBoundary" ] /*bash*/''
              projectDirs=(${bashArray})

              for dir in "''${projectDirs[@]}"; do
                mkdir -m700 -p "$dir" || echo "failed create $dir"
              done
            '';
        };
      };

      programs.fish.functions = commands // forkCommand;
    };
  };
}

