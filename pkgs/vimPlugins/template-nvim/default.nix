{ vimUtils
, fetchFromGitHub
, ...
}: vimUtils.buildVimPlugin {
  pname = "template.nvim";
  version = "07-05-2024";
  src = fetchFromGitHub {
    owner = "nvimdev";
    repo = "template.nvim";
    rev = "6b9a1acba0b34a31fdd8b70e7e1d7b114230b339";
    sha256 = "sha256-ti3a8rlsTqrkT2LuB79LIeGy8SGxphYnIpTegUi0e0M=";
  };
  meta.homepage = "https://github.com/nvimdev/template.nvim";
}
