{ config, pkgs, lib, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.lang;

  addProjectDirField = attr: builtins.mapAttrs (n: v: v // { projectDir = "$HOME/projects/own/${n}"; }) attr;

  avaiableIde = addProjectDirField (with pkgs.jetbrains; {
    python.package = pycharm-professional;
    cpp.package = clion;
    go.package = goland;
    dotnet.package = rider;
    rust.package = unstable.jetbrains.rust-rover;
    jvm.package = idea-ultimate;
    andorid.package = pkgs.andorid-studio;
  });

  langWithoutIde = {
    "fork" = "$HOME/projects/own/fork";
    "haskell" = "$HOME/projects/own/haskell";
  };

  ideNames = builtins.attrNames avaiableIde;
  langNames = builtins.attrNames langWithoutIde;

  installedIDEs = builtins.map (x: avaiableIde."${x}".package) cfg.ides;

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

  cmdCompletions = builtins.listToAttrs (builtins.map
    (x:
      let
        path = avaiableIde."${x}".projectDir;
      in
      rec {
        name = "p${x}";
        value = mkCompletions name path;
      })
    cfg.ides);

  commands = builtins.listToAttrs (builtins.map
    (x:
      let
        path = avaiableIde."${x}".projectDir;
      in
      {
        name = "p${x}";
        value = mkCommand path;
      })
    cfg.ides);


  langCmds = {
    commands = builtins.listToAttrs (builtins.map
      (x: {
        name = "p${x}";
        value = mkCommand langWithoutIde.${x};
      })
      cfg.lang);
    completions = builtins.listToAttrs (builtins.map
      (x: rec {
        name = "p${x}";
        value = mkCompletions name langWithoutIde.${x};
      })
      cfg.lang);
  };
in
{
  options = {
    modules.dev.lang = {
      lang = mkOption {
        type = with types; listOf (enum langNames);
        description = "List of aliases to language directories, that doesn't have IDE";
        default = [ ];
      };
      ides = mkOption {
        type = with types; listOf (enum ideNames);
        description = "List of enabled IDEs";
        default = [ ];
      };
    };
  };

  config = mkIf ((builtins.length (cfg.ides ++ cfg.lang)) != 0) {
    modules.shell.fish.completions = cmdCompletions // langCmds.completions;

    home-manager.users.wittano = {
      home = {
        packages = installedIDEs;
        activation = {
          createProjectsDir =
            let
              idesDirs = builtins.map (x: avaiableIde.${x}.projectDir) cfg.ides;
              langDirs = builtins.map (x: langWithoutIde.${x}) cfg.lang;
              bashArray = bash.mkBashArray (idesDirs ++ langDirs);
            in
            lib.hm.dag.entryBefore [ "writeBoundary" ] /*bash*/''
              projectDirs=(${bashArray})

              for dir in "''${projectDirs[@]}"; do
                mkdir -m700 -p "$dir" || echo "failed create $dir"
              done
            '';
        };
      };

      programs.fish.functions = commands // langCmds.commands;
    };
  };
}

