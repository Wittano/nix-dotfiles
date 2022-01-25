{ config, pkgs, lib, ... }:
let
  fishConfig = import ./fish;
  homeDir = "/home/wittano";
  configDir = "${homeDir}/dotfiles";
  xdgConfigFiles = [ "redshift.conf" "alacritty" "openbox" "polybar" "rofi" ];
  homeFiles = [ ".bg" ".themes" ".icons" ".vimrc" ];
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
    stateVersion = "21.11";
    file = linkConfigFiles homeFiles "";
    sessionVariables = { EDITOR = "nvim"; };
    packages = programs;

    activation.linkUpdatableConfigurationDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      echo "Run activation script!"

      bash $DOTFILES_DIR/scripts/directly-link-config-dirs.sh
    '';
  };

  xdg.configFile = linkConfigFiles xdgConfigFiles ".config/";

  programs.home-manager.enable = true;
}
