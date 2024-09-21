{ config, lib, pkgs, dotfiles, inputs, system, ... }:
with lib; with lib.my;
let
  cfg = config.modules.dev.emacs;
in
{
  options = {
    modules.dev.emacs = {
      enable = mkEnableOption "Enable Doom Emcas";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = rec {
      programs.emacs = {
        enable = cfg.enable;
        package = inputs.nix-doom-emacs.packages.${system}.default.override {
          doomPrivateDir = dotfiles.emacs.source;
        };
      };

      services.emacs = {
        enable = cfg.enable;
        package = programs.emacs.package;
        client.enable = cfg.enable;
        socketActivation.enable = cfg.enable;
        defaultEditor = cfg.enable;
      };

      home = {
        packages = with pkgs; [
          emacsPackages.vterm
          #(pkgs.emacs.override {withGTK3 = false; nativeComp = true;})
        ];
      };
    };
  };
}
