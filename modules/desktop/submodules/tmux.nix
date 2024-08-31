{ pkgs, lib, ... }:
with lib;
with lib.my; {
  config = {
    home-manager.users.wittano.programs = {
      fzf = {
        enable = true;
        enableFishIntegration = true;
        colors = {
          fg = "-1";
          bg = "-1";
          hl = "#5fff87";
          "fg+" = "-1";
          "bg+" = "-1";
          "hl+" = "#ffaf5f";
          "info" = "#af87ff";
          prompt = "#5fff87";
          pointer = "#ff87d7";
          marker = "#ff87d7";
          spinner = "#ff87d7";
        };
      };

      fish.shellAliases.tk = "tmux kill-session";

      tmux = {
        enable = true;
        mouse = true;
        newSession = false;
        catppuccin.enable = true;
        plugins = with pkgs.tmuxPlugins; [
          tmux-fzf
          sensible
          vim-tmux-navigator
          yank
        ];
        shell = "${pkgs.fish}/bin/fish";
        resizeAmount = 3;
        prefix = "C-n";
        baseIndex = 1;
        keyMode = "vi";
        extraConfig = ''
          set-option -sa terminal-overrides ",xterm*:Tc"

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toogle
          bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

          bind -n M-H previous-window
          bind -n M-L next-window

          bind p split-window -h
          bind o split-window -v
        '';
      };
    };
  };
}
