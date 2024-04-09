{ pkgs, ... }: {
  luaConfig = "require('nvim_comment').setup()";

  deps = with pkgs.vimPlugins; [ nvim-comment ];
}
