{ config, pkgs, lib, ... }:
let
  homeFiles = [ ".themes" ".icons" ];
  programs = with pkgs; [
    # Communicators
    signal-desktop
    discord

    # Utils
    redshift
    flameshot
    youtube-dl

    # Organizations
    joplin-desktop

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
    alacritty
    vscode
  ];
in {
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    stateVersion = "21.11";
    # file = linkConfigFiles homeFiles "";
    sessionVariables = { EDITOR = "nvim"; };
    packages = programs;

    # activation.linkUpdatableConfigurationDirs =
    #   lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #     echo "Run activation script!"

    #     bash $DOTFILES_DIR/scripts/directly-link-config-dirs.sh
    #   '';
  };

  # xdg.configFile = linkConfigFiles xdgConfigFiles ".config/";

  # programs.home-manager.enable = true;
}
