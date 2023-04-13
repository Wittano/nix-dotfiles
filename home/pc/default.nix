{ config, pkgs, lib, unstable, ... }:
with lib.my;
let
  programs = with pkgs; [
    # Utils
    flameshot

    # Web browser
    vivaldi

    # Apps
    thunderbird
    gnome.file-roller
    keepassxc
    gnome.eog
    spotify
    evince
    pcmanfm

    # Dev
    vscodium
  ];
in
{
  # TODO Add automatically download NixOS dotfiles and other related projects
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    packages = programs;
  };
}
