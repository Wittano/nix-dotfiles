{ privateRepo, ... }: {
  luaConfig = ''
    require('nvim_comment').setup()
  '';

  deps = with privateRepo; [ nvim-comment ];
}
