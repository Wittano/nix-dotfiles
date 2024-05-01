{ pkgs, lib, dotfiles, ... }:
with lib;
with lib.my; {
  mutableSources = {
    ".config/kitty" = dotfiles.kitty.source;
  };
  config = {
    # TODO Migate to home-manager options
    home-manager.users.wittano = {
      home.packages = with pkgs; [ kitty ];

      programs.fish.shellAliases.ssh = "kitty +kitten ssh";
    };
  };
}
