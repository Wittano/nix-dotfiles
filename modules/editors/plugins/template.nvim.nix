{ srcOnly, privateRepo, ... }:
let
  templateDir = srcOnly {
    pname = "template-dir";
    version = "28-12-2023";
    src = ./templates;
  };
in
{
  luaConfig = ''
    require('template').setup({
      temp_dir = "${templateDir}",
      author = "Wittano",
    })

    require("telescope").load_extension('find_template')
  '';

  deps = with privateRepo; [ template-nvim ];
}
