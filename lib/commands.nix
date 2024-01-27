{ lib, pkgs, home-manager, ... }: {
  createProjectJumpCommand = path:
    let
      commandName = "p${builtins.baseNameOf path}";
      command = pkgs.writeScriptBin "${commandName}" /*bash*/ ''
        #!/usr/bin/env bash

        if [ -n "$1" ]; then
          cd "${path}/$1"
        else
          cd "${path}"
        fi
      '';
    in
    {
      home-manager.users.wittano.programs.fish = {
        interactiveShellInit = /*fish*/''
          function get_projects_dir
            ls ${path}
          end

          for project in (get_projects_dir)
            complete -c ${commandName} -f -a "$project"
          end
        '';
        functions.${commandName}.body = /*fish*/''
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
