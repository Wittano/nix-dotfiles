{ config, pkgs, lib, unstable, ... }:
with lib.my;
let
  programs = with pkgs; [
    # Utils
    flameshot

    # Web browser
    vivaldi

    # Utils 
    thunderbird
    gnome.eog
    evince
    onlyoffice-bin
    soundux

    # Apps
    spotify
    freetube # Youtube desktop
    streamlink-twitch-gui-bin # Twitch desktop
    mpv
    joplin-desktop
    vscodium

    # Security
    bitwarden
    keepassxc

    # Communicator
    telegram-desktop
    signal-desktop
    discord
  ];
in
{
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    packages = programs;
  };
}
