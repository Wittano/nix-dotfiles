{ lib, fetchFromGitHub, go, gomodifytags, gotests, impl, iferr, vimUtils
, vimPlugins, ... }: {
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

  plugin = vimUtils.buildVimPlugin {
    pname = "gopher.nvim";
    version = "v0.1.4";
    src = fetchFromGitHub {
      owner = "olexsmir";
      repo = "gopher.nvim";
      rev = "03cabf675ce129c28bd855969a3e569edcf63366";
      sha256 = "sha256-GeMvWb/5/e9TMycPNKS+ZvY8ODiWJA7wvP5wan+9CL4=";
    };
    meta.homepage = "https://github.com/olexsmir/gopher.nvim";
  };

  deps = let
    plenaryNvim = vimUtils.buildVimPlugin {
      pname = "plenary.nvim";
      version = "v0.1.4";
      src = fetchFromGitHub {
        owner = "nvim-lua";
        repo = "plenary.nvim";
        rev = "50012918b2fc8357b87cff2a7f7f0446e47da174";
        sha256 = "sha256-zR44d9MowLG1lIbvrRaFTpO/HXKKrO6lbtZfvvTdx+o=";
      };
      meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
    };
  in with vimPlugins; [ nvim-treesitter plenaryNvim ];
}

