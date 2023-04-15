{ cfg, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
{
  home-manager.users.wittano.home = {
    packages = with pkgs; [ tmux ];

    activation.linkMutableTmuxConfig =
      link.createMutableLinkActivation {
        internalPath = ".tmux.conf";
        isDevMode = cfg.enableDevMode;
      };

    file = mkIf (cfg.enableDevMode == false) {
      ".tmux.conf".source = dotfiles.".tmux.conf".source;
    };
  };
}
