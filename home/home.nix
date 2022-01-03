{ config, pkgs, ... }:
let
  fishConfig = import ./fish/fish.nix;
  homeDir = "/home/wittano";
  configDir = "${homeDir}/dotfiles";
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "wittano";
  home.homeDirectory = homeDir;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    arandr
    joplin-desktop
    lxappearance
    rhythmbox
    signal-desktop
    vivaldi
    nitrogen
    rofi
    openbox-menu
    lxmenu-data
    obconf
    polybar
    thunderbird
    gnome.nautilus
    gnome.file-roller
    flameshot
    keepassxc
    discord
    minecraft
    redshift
    vscode
    alacritty
    tmux
    gnome.eog
  ];

  # Session variables
  home.sessionVariables = {
    EDITOR="nvim";
  };

  # Dirs and config files
  xdg.configFile = {
    "redshift.conf".source = "${configDir}/.config/redshift.conf";
    "alacritty".source = "${configDir}/.config/alacritty";
    "i3".source = "${configDir}/.config/i3";
    "nitrogen".source = "${configDir}/.config/nitrogen";
    "openbox".source = "${configDir}/.config/openbox";
    "polybar".source = "${configDir}/.config/polybar";
    "qtile".source = "${configDir}/.config/qtile";
    "qutebrowser".source = "${configDir}/.config/qutebrowser";
    "ranger".source = "${configDir}/.config/ranger";
    "rofi".source = "${configDir}/.config/rofi";
    "sxhkd".source = "${configDir}/.config/sxhkd";
    "terminator".source = "${configDir}/.config/terminator";
    "tint2".source = "${configDir}/.config/tint2";
  };

  home.file = {
    ".bg".source = "${configDir}/.bg";
    ".themes".source = "${configDir}/.themes";
    ".icons".source = "${configDir}/.icons";
  };


  # Programs
  programs = {
    home-manager.enable = true;

    fish = fishConfig pkgs;

    git = {
      enable = true;
      userName = "wittano";
      userEmail = "radoslaw.ratyna@gmail.com";
      extraConfig = {
        core.editor = "vim";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    neovim = {
      enable = true;
      extraConfig = ''
        set rnu nu
      '';
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-go
        coc-go
      ];
      viAlias = true;
      vimdiffAlias = true;
      withNodeJs = true; # for coc.nvim
      withPython3 = true; # for plugins
    };

  };
}
