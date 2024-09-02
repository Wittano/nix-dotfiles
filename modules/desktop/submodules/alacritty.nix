{ pkgs, lib, ... }:
with lib;
with lib.my;
{
  config = {
    fonts.packages = with pkgs; [ jetbrains-mono ];

    home-manager.users.wittano.programs.alacritty = {
      enable = true;
      settings = {
        general = {
          shell = "${pkgs.fish}/bin/fish";
          "live_config_reload" = false;
        };
        env.TERM = "xterm-256color";
        window = {
          opacity = 1;
          dimensions = {
            columns = 0;
            lines = 0;
          };
          padding = {
            x = 2;
            y = 2;
          };
          decorations = "full";
        };
        scrolling = {
          history = 10000;
          multiplier = 10;
        };
        tabspaces = 4;
        font = {
          normal.family = "JetBrains Mono";
          bold.family = "JetBrains Mono";
          italic.family = "JetBrains Mono";
          size = 14.0;
          offset = {
            x = 0;
            y = 0;
          };
        };
        colors."draw_bold_text_with_bright_colors" = true;
        bell = {
          animation = "EaseOutExpo";
          duration = 300;
        };
        mouse = {
          bindings = [{
            action = "PasteSelection";
            mouse = "Middle";
          }];
        };
        selection."semantic_escape_chars" = '',|`|:"' (){}[]<>'';
      };
    };
  };
}
