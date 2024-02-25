{ config, pkgs, home-manager, lib, ... }:
with lib;
let cfg = config.modules.dev.git;
in
{
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
    home-manager.users.wittano = {
      home.packages = with pkgs; [ lazygit ];
      services.gpg-agent = {
        enable = true;
        pinentryFlavor = "gtk2";
      };

      programs = rec {
        git = rec {
          enable = true;
          userName = "Wittano Bonarotti";
          userEmail = "radoslaw.ratyna@gmail.com";
          extraConfig = {
            core.editor = "vim";
            init.defaultBranch = "main";
            pull.rebase = true;
            commit.gpgsign = true;
          };
        };

        gpg.enable = true;

        fish = mkIf config.modules.shell.fish.enable {
          shellAliases.lg = "lazygit";
          shellAbbrs = {
            gst = "git status";
            gc = "git commit -v";
            "gc!" = "git commit --amend";
            gaa = "git add .";
            ga = "git add";
            ggpush = "git push";
            ggpull = "git pull";
          };
        };
      };
    };
  };

}
