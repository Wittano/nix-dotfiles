{ config, lib, unstable, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.lang;

  homeDir = config.home-manager.users.wittano.home.homeDirectory;
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
          home-manager.users.wittano.home.packages = mkIf (ide ? package) [ ide.package ];
          home-manager.users.wittano.home.file.".ideavimrc".text = "set rnu nu";
        }
        (ide.extraConfig or { })
      ];
    in
    addProjectDirField (with unstable.jetbrains; rec {
      python = let forkConfig = mkExtraConfig fork; in {
        package = pycharm-professional;
        extraConfig = forkConfig;
      };
      cpp.package = clion;
      zig = cpp;
      go.package = goland.overrideAttrs (attrs: {
        postFixup = (attrs.postFixup or "") + lib.optionalString pkgs.stdenv.isLinux ''
          if [ -f $out/goland/plugins/go-plugin/lib/dlv/linux/dlv ]; then
            rm $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
          fi

          ln -s ${unstable.delve}/bin/dlv $out/goland/plugins/go-plugin/lib/dlv/linux/dlv
        '';
      });
      dotnet.package = rider;
      rust.package = rust-rover;
      jvm.package = idea-ultimate;
      sql.package = datagrip;
      web.package = webstorm;
      andorid.package = unstable.andorid-studio;
      haskell.extraConfig = {
        modules.dev.neovim.enable = true;
      };
      fork.extraConfig = {
        modules.dev.neovim.enable = true;
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
  options = {
    modules.dev.lang = {
      ides = mkOption {
        type = with types; listOf (enum ideNames);
        description = "List of enabled IDEs";
        default = [ ];
      };
    };
  };

  config = mkIf ((builtins.length cfg.ides) != 0) (mkMerge [
    extraConfigs
    {
      modules.shell.fish.completions = builtins.listToAttrs (cmdCompletions ++ extraCompletions);

      home-manager.users.wittano = {
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
      };
    }
  ]);
}

