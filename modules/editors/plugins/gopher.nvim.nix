{ go
, gomodifytags
, gotests
, impl
, iferr
, privateRepo
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

  deps = with privateRepo; [ vimPlugins.nvim-treesitter gopher-nvim plenary-nvim ];
}

