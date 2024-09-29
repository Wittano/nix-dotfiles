{ config, lib, unstable, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.dev.lang;

  projectDir = "${config.home-manager.users.wittano.home.homeDirectory}/projects";
  addProjectDirField = attr: builtins.mapAttrs (n: v: v // { projectDir = "${projectDir}/${n}"; }) attr;

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
        home-manager.users.wittano.home.packages = with unstable; [ zed-editor ];
      };
      fork.extraConfig = {
        home-manager.users.wittano.home.packages = with unstable; [ vscodium ];
      };
    });

  installedIDEs = trivial.pipe cfg.ides [
    (builtins.map (x: avaiableIde."${x}".package or null))
    (builtins.filter (x: x != null))
  ];

  cmdCompletions = trivial.pipe cfg.ides [
    (builtins.map
      (x:
        let
          path = avaiableIde."${x}".projectDir;
        in
        rec {
          name = "p${x}";
          value = ''
            function get_projects_dir
              ls ${path} || echo ""
            end

            for project in (get_projects_dir)
              complete -c ${name} -f -a "$project"
            end
          '';
        }))
    builtins.listToAttrs
  ];

  commands = trivial.pipe cfg.ides [
    (builtins.map
      (x:
        let
          path = avaiableIde."${x}".projectDir;
        in
        {
          name = "p${x}";
          value = {
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
        })
    )
    builtins.listToAttrs
  ];

  ideNames = builtins.attrNames avaiableIde;
  extraConfigs = trivial.pipe ideNames [
    (builtins.map (x: avaiableIde.${x}.extraConfig or { }))
    mkMerge
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
      modules.shell.fish.completions = cmdCompletions;

      home-manager.users.wittano = {
        gtk.gtk3.bookmarks = [
          "file://${projectDir} Projects"
        ];
        home = {
          packages = installedIDEs;
          activation.createProjectsDir =
            let
              idesDirs = builtins.map (x: avaiableIde.${x}.projectDir) cfg.ides;
              bashArray = bash.mkBashArray (idesDirs);
            in
            lib.hm.dag.entryBefore [ "writeBoundary" ] /*bash*/''
              projectDirs=(${bashArray})

              for dir in "''${projectDirs[@]}"; do
                mkdir -m700 -p "$dir" || echo "failed create $dir"
              done
            '';
        };

        programs.fish.functions = commands;
      };
    }
  ]);
}

