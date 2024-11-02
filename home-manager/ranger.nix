{ config, pkgs, lib, ... }:
with lib;
{
  options.programs.ranger.wittano.enable = mkEnableOption "Enable custom ranger config";

  config = mkIf config.programs.ranger.wittano.enable {
    programs.fish.shellAliases.ra = "ranger";
    programs.ranger = {
      enable = true;
      extraPackages = with pkgs; [ ueberzug ];
      settings = {
        "show_hidden" = true;
        "draw_borders" = "both";
        "draw_progress_bar_in_status_bar" = true;
        "display_size_in_status_bar" = true;
        "display_free_space_in_status_bar" = true;
        "line_numbers" = "relative";
        "size_in_bytes" = true;
        "mouse_enabled" = false;
        "preview_files" = true;
        "preview_images" = true;
        "preview_images_method" = "ueberzug";
        "relative_current_zero" = false;
        "save_console_history" = false;
        "tilde_in_titlebar" = true;
        "update_title" = true;
        "update_tmux_title" = true;
      };
    };
  };
}
