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
    gnome.eog
    spotify
    evince
    soundux
    freetube
    onlyoffice-bin

    # Security
    bitwarden
    keepassxc

    # Communicator
    telegram-desktop
    signal-desktop
    discord
  ];
in {
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    packages = programs;
  };
}
