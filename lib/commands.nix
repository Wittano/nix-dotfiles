{ lib, pkgs, home-manager, ... }:
with lib;
{
  createProjectJumpCommand = config: path:
    let commandName = "p${builtins.baseNameOf path}"; in
    {
      home-manager.users.wittano = rec {
        xdg.configFile."fish/completions/${commandName}.fish".text = mkIf (config.home-manager.users.wittano.programs.fish.enable) /*fish*/''
          function get_projects_dir
            ls ${path}
          end

          for project in (get_projects_dir)
            complete -c ${commandName} -f -a "$project"
          end
        '';

        programs.fish.functions.${commandName}.body = /*fish*/''
          set -l args_len $(count $argv)

          if test "$args_len" -eq 0
            cd ${path}
          else
            cd ${path}/$argv
          end
        '';
      };
    };
}
