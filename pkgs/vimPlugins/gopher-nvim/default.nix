{ vimUtils
, fetchFromGitHub
, lib
, ...
}: vimUtils.buildVimPlugin {
  pname = "gopher.nvim";
  version = "v0.1.4";
  src = fetchFromGitHub {
    owner = "olexsmir";
    repo = "gopher.nvim";
    rev = "03cabf675ce129c28bd855969a3e569edcf63366";
    sha256 = "sha256-GeMvWb/5/e9TMycPNKS+ZvY8ODiWJA7wvP5wan+9CL4=";
  };
  meta.homepage = "https://github.com/olexsmir/gopher.nvim";
}
