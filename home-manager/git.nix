{ config, pkgs, lib, ... }:
with lib;
let cfg = config.programs.git.wittano;
in
{
  options.programs.git.wittano.enable = mkEnableOption "Enable custmo git confgi";

  config = mkIf cfg.enable {
    # services.dbus.packages = with pkgs; [ gcr ];

    home.packages = with pkgs; [ xclip ];
    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-all;
    };

    programs = {
      git = {
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

      lazygit.enable = true;

      gpg.enable = true;

      fish = mkIf config.programs.fish.wittano.enable {
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

}
