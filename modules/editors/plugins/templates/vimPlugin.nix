{ vimUtils, lib, fetchFromGitHub, vimPlugins, ... }: {
  luaConfig = ''
    require('{{_file_name_}}').setup()
  '';

  plugin = vimUtils.buildVimPlugin {
    pname = "{{_file_name_}}";
    version = "{{_date_}}";
    src = fetchFromGitHub {
      owner = "";
      repo = "{{_file_name_}}.nvim";
      rev = "41a41541f6af19be5403c0a5bf371d8ccb86c9c4";
      sha256 = lib.fakeSha256;
    };
    meta.homepage = "https://github.com/";
  };

  deps = with vimPlugins; [ ];
}
