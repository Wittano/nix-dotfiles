{ config, pkgs, lib, unstable, ... }:
with lib.my;
let
  programs = with pkgs; [
    # Communicators
    signal-desktop
    discord
    spotify

    # Utils
    flameshot
    youtube-dl

    # Organizations
    unstable.joplin-desktop

    # Web browser
    vivaldi

    # Apps
    rhythmbox
    thunderbird
    gnome.nautilus
    gnome.file-roller
    keepassxc
    gnome.eog
    krita
    evince

    # Dev
    vscode
  ];
in {
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    stateVersion = "21.11";
    packages = programs;
  };
}
