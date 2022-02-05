{ config, pkgs, home-manager, lib, ... }:
with lib;
let cfg = config.modules.dev.git;
in {
  options = {
    modules.dev.git = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable git";
      };

      useGpg = mkEnableOption ''
        Enable GnuPG to signing commits
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      services.gpg-agent.enable = cfg.useGpg;

      programs = rec {
        git = rec {
          enable = true;
          userName = "Wittano";
          userEmail = "radoslaw.ratyna@gmail.com";
          extraConfig = {
            core.editor = "vim";
            init.defaultBranch = "main";
            pull.rebase = true;
          };
        };

        gpg.enable = cfg.useGpg;

        fish = mkIf config.modules.shell.fish.enable {
          shellAbbrs = {
            gst = "git status";
            gc = "git commit";
            "gc!" = "git commit --amend";
            gaa = "git add .";
            ggpush = "git push";
            ggpull = "git pull";
          };
        };
      };
    };
  };

}
