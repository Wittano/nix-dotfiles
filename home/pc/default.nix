{ config, pkgs, lib, unstable, ... }:
with lib.my;
let
  programs = with pkgs; [
    # Communicators
    signal-desktop
    spotify

    # Utils
    flameshot

    # Organizations
    obsidian

    # Web browser
    vivaldi

    # Apps
    thunderbird
    gnome.nautilus
    gnome.file-roller
    keepassxc
    gnome.eog
    krita
    evince

    # Dev
    vscodium
  ];
in
{
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    packages = programs;
  };
}
