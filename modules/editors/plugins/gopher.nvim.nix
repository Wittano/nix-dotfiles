{ go
, gomodifytags
, gotests
, impl
, iferr
, gopher-nvim # Package from private repository
, vimPlugins
, ...
}: {
  luaConfig = ''
    require("gopher").setup {
      commands = {
        go = "${go}/bin/go",
        gomodifytags = "${gomodifytags}/bin/gomodifytags",
        gotests = "${gotests}/bin/gotests",
        impl = "${impl}/bin/impl",
        iferr = "${iferr}/bin/iferr",
      },
    }
  '';

  deps = with vimPlugins; [ vimPlugins.nvim-treesitter gopher-nvim plenary-nvim ];
}

