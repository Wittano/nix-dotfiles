{ config, lib, unstable ? pkgs, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.programs.jetbrains;

  homeDir = config.home.homeDirectory;
  projectDir = "${homeDir}/projects";
  addProjectDirField = attr: builtins.mapAttrs (n: v: v // { projectDir = "${projectDir}/${n}"; }) attr;

  mkCmdCompletion = path: assert builtins.typeOf path == "string";
    let
      basename = builtins.baseNameOf path;
      name = "p${basename}";
      funcName = "get_${name}_projects_dir";
    in
    ''
      function ${funcName}
        ls ${path} || echo ""
      end

      for project in (${funcName})
        complete -c ${name} -f -a "$project"
      end
    '';

  mkCmdCommand = path: assert builtins.typeOf path == "string"; {
    body = /*fish*/ ''
      mkdir -p ${path}

      set -l args_len $(count $argv)

      if test "$args_len" -eq 0
        cd ${path}
      else
        cd ${path}/$argv
      end
    '';
  };

  avaiableIde =
    let
      mkExtraConfig = ide: mkMerge [
        {
          home.packages = mkIf (ide ? package) [ ide.package ];
          home.file.".ideavimrc".text = "set rnu nu";
        }
        (ide.extraConfig or { })
      ];
    in
    addProjectDirField (with unstable.jetbrains; rec {
      python = {
        package = pycharm-professional;
        extraConfig = mkExtraConfig fork;
      };
      cpp.package = clion;
      zig = cpp;
      go = {
        package = goland;
        extraConfig = {
          home.packages = with pkgs; [ golangci-lint ];
        };
      };
      dotnet.package = rider;
      rust.package = rust-rover;
      jvm.package = idea-ultimate;
      sql.package = datagrip;
      web.package = webstorm;
      andorid.package = unstable.andorid-studio;
      haskell.extraConfig = fork.extraConfig;
      elixir.extraConfig = haskell.extraConfig;
      fork.extraConfig = {
        programs.nixvim.enable = true;
      };
    });

  installedIDEs = trivial.pipe cfg.ides [
    (builtins.map (x: avaiableIde."${x}".package or null))
    (builtins.filter (x: x != null))
  ];

  cmdCompletions = builtins.map
    (x: {
      name = "p${x}";
      value = mkCmdCompletion avaiableIde."${x}".projectDir;
    })
    cfg.ides;

  commands = builtins.map
    (x:
      {
        name = "p${x}";
        value = mkCmdCommand avaiableIde."${x}".projectDir;
      }
    )
    cfg.ides;

  ideNames = builtins.attrNames avaiableIde;
  extraConfigs = trivial.pipe ideNames [
    (builtins.map (x: avaiableIde.${x}.extraConfig or { }))
    mkMerge
  ];

  serverPath = "${homeDir}/projects/server";
  extraCommands = [
    {
      name = "pserver";
      value = mkCmdCommand serverPath;
    }
  ];
  extraCompletions = [
    {
      name = "pserver";
      value = mkCmdCompletion serverPath;
    }
  ];
in
{
  options.programs.jetbrains = {
    ides = mkOption {
      type = with types; listOf (enum ideNames);
      description = "List of enabled IDEs";
      default = [ ];
    };
  };

  config = mkIf ((builtins.length cfg.ides) != 0) (mkMerge [
    extraConfigs
    {
      programs.fish.wittano.completions = builtins.listToAttrs (cmdCompletions ++ extraCompletions);

      gtk.gtk3.bookmarks = [
        "file://${projectDir} Projects"
      ];
      home = {
        packages = installedIDEs;
        activation.createProjectsDir =
          let
            idesDirs = builtins.map (x: avaiableIde.${x}.projectDir) cfg.ides;
            bashArray = bash.mkBashArray idesDirs;
          in
          lib.hm.dag.entryBefore [ "writeBoundary" ] /*bash*/''
            projectDirs=(${bashArray})

            for dir in "''${projectDirs[@]}"; do
              mkdir -m700 -p "$dir" || echo "failed create $dir"
            done
          '';
      };

      programs.fish.functions = builtins.listToAttrs (commands ++ extraCommands);
    }
  ]);
}
