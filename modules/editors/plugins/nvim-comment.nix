{ pkgs, ... }: {
  luaConfig = "";

  deps = with pkgs.vimPlugins; [ nvim-comment ];
}
