{ config, pkgs ? <nixpkgs>, ... }: {
  programs.neovim = {
    enable = true;
    extraConfig = ''
      set rnu nu
    '';
    plugins = with pkgs.vimPlugins; [ vim-nix vim-go coc-go ];
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true; # for coc.nvim
    withPython3 = true; # for plugins
  };
}
