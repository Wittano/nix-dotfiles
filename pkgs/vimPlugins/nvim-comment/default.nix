{ vimUtils
, fetchFromGitHub
, lib
, ...
}: vimUtils.buildVimPlugin {
  pname = "nvim-comment";
  version = "30-12-2023";
  src = fetchFromGitHub {
    owner = "terrortylor";
    repo = "nvim-comment";
    rev = "e9ac16ab056695cad6461173693069ec070d2b23";
    sha256 = "sha256-O2jhrjXxKaWHMfm3YJ9+92Onm0niEHfUp5kOh2gETuc=";
  };
  meta.homepage = "https://github.com/terrortylor/nvim-comment";
}
