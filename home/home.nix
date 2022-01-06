{ config, pkgs, ... }:
let
  fishConfig = import ./fish;
  homeDir = "/home/wittano";
  configDir = "${homeDir}/dotfiles";
  xdgConfigFiles =
    [ "redshift.conf" "alacritty" "nitrogen" "openbox" "polybar" "rofi" ];
  homeFiles = [ ".bg" ".themes" ".icons" ".vimrc" ".tmux.conf" ];
  programs = with pkgs; [
    # Communicators
    signal-desktop
    discord

    # Utils
    arandr
    lxappearance
    nitrogen
    redshift
    flameshot
    htop

    # Organizations
    joplin-desktop

    # Desktop
    rofi
    openbox-menu
    lxmenu-data
    obconf
    polybar

    # Apps
    rhythmbox
    vivaldi
    thunderbird
    gnome.nautilus
    gnome.file-roller
    keepassxc
    gnome.eog
    krita

    # Dev
    alacritty
    vscode
    tmux

    # Games
    steam
    steam-run-native
  ];

  # Funcations
  linkConfigFiles = list: path:
    let
      attr = map (x: {
        name = x;
        value = { source = "${configDir}/${path}${x}"; };
      }) list;
    in builtins.listToAttrs attr;
in {
  nixpkgs.config.allowUnfree = true;

  imports = [ ./fish.nix ./git.nix ./neovim ];

  home = {
    username = "wittano";
    homeDirectory = homeDir;
    stateVersion = "21.05";
    file = linkConfigFiles homeFiles "";
    sessionVariables = { EDITOR = "nvim"; };
    packages = programs;
  };

  xdg.configFile = linkConfigFiles xdgConfigFiles ".config/";

  programs.home-manager.enable = true;
}
