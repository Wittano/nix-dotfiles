{ config, pkgs, lib, home-manager, dotfiles, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.editors.emacs;
in {
  options = {
    modules.editors.emacs = {
      enable = mkEnableOption ''
        Enable Emacs editor
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home = {
      packages = with pkgs; [ emacs rnix-lsp wakatime ];
    };
  };
}
