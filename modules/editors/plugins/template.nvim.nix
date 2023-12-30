{ srcOnly, vimUtils, lib, fetchFromGitHub, ... }:
let
  templateDir = srcOnly {
    pname = "template-dir";
    version = "28-12-2023";
    src = ./templates;
  }; in
{
  luaConfig = ''
    require('template').setup({
      temp_dir = "${templateDir}",
      author = "Wittano",
    })

    require("telescope").load_extension('find_template')
  '';

  plugin = vimUtils.buildVimPlugin {
    pname = "template.nvim";
    version = "27-12-2023";
    src = fetchFromGitHub {
      owner = "nvimdev";
      repo = "template.nvim";
      rev = "41a41541f6af19be5403c0a5bf371d8ccb86c9c4";
      sha256 = "sha256-rBD0AnPJMU8Fkgu6UJp4+hpro8tn1OMCQi4VirRlFNA=";
    };
    meta.homepage = "https://github.com/nvimdev/template.nvim";
  };

  deps = [ ];
}
