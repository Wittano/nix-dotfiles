{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "wittano";
  home.homeDirectory = "/home/wittano";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    firefox
    nitrogen
    neofetch
    rofi
    terminator
    vscode
    lxappearance
    openbox-menu
    lxmenu-data
    obconf
    polybar
    rnix-lsp
    thunderbird
    xfce.thunar
    xfce.exo
    flameshot
  ];

  # Programs
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "wittano";
      userEmail = "radoslaw.ratyna@gmail.com";
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      extraConfig = ''
        source $HOME_MANAGER_CONFIG_DIR/nixpkgs/base.vim
        set rnu nu
      '';
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
      viAlias = true;
      vimdiffAlias = true;
      withNodeJs = true; # for coc.nvim
      withPython3 = true; # for plugins
    };
  };
}
