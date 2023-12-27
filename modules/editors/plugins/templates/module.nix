{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.{{_lua:vim.fn.expand("%:h"):gsub("/", ".")_}}.{{_file_name_}};
in
{
  options = {
    {{_lua:vim.fn.expand("%:h"):gsub("/", ".")_}}.{{_file_name_}} = {
      enable = mkEnableOption "Enable ";
    };
  };

  config = mkIf (cfg.enable) {
    {{_cursor_}}
  };
}
