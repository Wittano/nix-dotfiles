{ vimUtils
, fetchFromGitHub
, lib
, ...
}: vimUtils.buildVimPlugin {
  pname = "template.nvim";
  version = "27-12-2023";
  src = fetchFromGitHub {
    owner = "nvimdev";
    repo = "template.nvim";
    rev = "41a41541f6af19be5403c0a5bf371d8ccb86c9c4";
    sha256 = "sha256-rBD0AnPJMU8Fkgu6UJp4+hpro8tn1OMCQi4VirRlFNA=";
  };
  meta.homepage = "https://github.com/nvimdev/template.nvim";
}
