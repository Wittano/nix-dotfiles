{ pkgs, home-manager, lib, dotfiles, cfg, ... }:
with lib;
with lib.my; {
  home-manager.users.wittano = {
    home.packages = with pkgs; [ kitty ];

    programs.fish.shellAliases.ssh = "kitty +kitten ssh";

    xdg.configFile."kitty".source = dotfiles.kitty.source;
  };
}
