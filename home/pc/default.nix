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
    gnome.eog
    spotify
    evince
    cinnamon.nemo
    obsidian
    soundux

    # Security
    bitwarden
    keepassxc

    # Communicator
    telegram-desktop
    signal-desktop
    discord
    gotktrix

    # Dev
    vscodium
    figma-linux
  ];
in {
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    packages = programs;
  };
}
