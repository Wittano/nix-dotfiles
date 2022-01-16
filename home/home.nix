{ config, pkgs, ... }:
let
  fishConfig = import ./fish;
  homeDir = "/home/wittano";
  configDir = "${homeDir}/dotfiles";
  xdgConfigFiles = [
    "redshift.conf"
    "alacritty"
    "nitrogen"
    "openbox"
    "polybar"
    "rofi"
    "tint2"
  ];
  homeFiles = [ ".bg" ".themes" ".icons" ".vimrc" ];
  programs = with pkgs; [
    # Communicators
    signal-desktop
    discord

    # Utils
    redshift
    flameshot

    # Organizations
    joplin-desktop

    # Apps
    rhythmbox
    vivaldi
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

  imports = [ ./fish.nix ./git.nix ./neovim ./programming ./gaming ];

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
