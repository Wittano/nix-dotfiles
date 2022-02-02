{ config, pkgs, home-manager, lib, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.modules.dev.git;
in {
  options = {
    modules.dev.git = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable git";
      };
    };
  };

  config = mkIf cfg.enable {

    home-manager.users.wittano.home.programs = {
      git = {
        enable = true;
        userName = "Wittano";
        userEmail = "radoslaw.ratyna@gmail.com";
        extraConfig = {
          core.editor = "vim";
          init.defaultBranch = "main";
          pull.rebase = true;
        };
      };

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

}
