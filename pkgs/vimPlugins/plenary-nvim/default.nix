{ vimUtils
, fetchFromGitHub
, lib
, ...
}: vimUtils.buildVimPlugin {
  pname = "plenary.nvim";
  version = "v0.1.4";
  src = fetchFromGitHub {
    owner = "nvim-lua";
    repo = "plenary.nvim";
    rev = "50012918b2fc8357b87cff2a7f7f0446e47da174";
    sha256 = "sha256-zR44d9MowLG1lIbvrRaFTpO/HXKKrO6lbtZfvvTdx+o=";
  };
  meta.homepage = "https://github.com/nvim-lua/plenary.nvim";
}
