{ config, pkgs, lib, home-manager, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.editors.neovim;
in {
  options = {
    modules.editors.neovim = {
      enable = mkEnableOption ''
        Enable Neovim editor
      '';
    };
  };

  # TODO Create full neovim configuration 
  config = mkIf cfg.enable {
    home-manager.users.wittano.programs = {
      neovim = {
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
    };
  };
}
