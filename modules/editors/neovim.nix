{ config, pkgs, lib, home-manager, mainUser, ... }:
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

  config = mkIf cfg.enable {
    home-manager.users.${mainUser}.home = {
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
    };
  };
}
