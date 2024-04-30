{ pkgs, lib, dotfiles, desktopName, ... }:
with lib;
with lib.my; {
  # TODO Migate to home-manager options
  home-manager.users.wittano = {
    home.packages = with pkgs; [ kitty ];

    programs.fish.shellAliases.ssh = "kitty +kitten ssh";
  };

  modules.desktop.${desktopName}.mutableSources = {
    ".config/kitty" = dotfiles.kitty.source;
  };
}
