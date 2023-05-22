{ config, pkgs, lib, unstable, ... }:
with lib.my;
let
  programs = with pkgs; [
    # Utils
    flameshot

    # Web browser
    unstable.vivaldi

    # Apps
    thunderbird
    gnome.file-roller
    keepassxc
    gnome.eog
    spotify
    evince
    gotktrix
    pcmanfm
    discord

    # Dev
    vscodium
  ];
in {
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    packages = programs;
  };
}
