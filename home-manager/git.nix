{ config, pkgs, lib, ... }:
with lib;
let cfg = config.programs.git.wittano;
in
{
  options.programs.git.wittano.enable = mkEnableOption "Enable custmo git confgi";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ xclip ];
    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-all;
    };

    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "Wittano Bonarotti";
            email = "radoslaw.ratyna@gmail.com";
          };
          core.editor = "vim";
          init.defaultBranch = "main";
          pull.rebase = true;
          commit.gpgsign = true;
        };
      };

      lazygit.enable = true;

      gpg.enable = true;

      fish = mkIf config.programs.fish.wittano.enable {
        shellAliases.lg = "lazygit";
        shellAbbrs = {
          gst = "git status -s";
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

}
