{ lib, dotfiles }:
builtins.mapAttrs (n: v: "${dotfiles}/.config/${n}") (builtins.readDir "${dotfiles}/.config")
