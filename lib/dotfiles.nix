{ lib, dotfiles }:
builtins.mapAttrs (n: v: "${dotfiles}/${n}") (builtins.readDir dotfiles)
