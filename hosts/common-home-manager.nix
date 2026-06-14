{ inputs, systemVersion, pkgs, accent ? "pink", flavor ? "latte", desktopName, ... }: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nixvim.homeModules.nixvim
    ./../home-manager
  ];

  home = {
    stateVersion = systemVersion;
    packages = with pkgs; [
      # Utils
      textsnatcher # Text extractor
      sniffnet # Network monitoring

      # Folder Dialog menu
      zenity

      # Web browser
      vivaldi
      firefox

      # Utils
      eog # Image viewer
      libreoffice # Office staff

      # Apps
      keepassxc # Password manager
      xournalpp # Handwritten notebook
      darktable # Photo editing
      obsidian

      # Security
      keepassxc
    ];
  };

  programs = {
    nemo.enable = true;
    thunderbird.wittano.enable = true;
    file-roller.enable = true;
    git.wittano.enable = true;
    btop.enable = true;
    ghostty.wittano.enable = true;
    vivaldi.wittano.enable = true;
    signal = {
      enable = true;
      enableAutostart = true;
    };
    joplin.enable = true;
    telegram = {
      enable = true;
      enableAutostart = true;
    };
    matrix = {
      enable = true;
      enableAutostart = true;
    };
    fish = {
      wittano = {
        enable = true;
        enableDirenv = true;
      };
      shellAliases.open = "xdg-open";
    };
    rofi.wittano = {
      inherit desktopName;

      enable = true;
    };
    mpv.enable = true;
  };

  qt.wittano.enable = true;
  gtk.wittano.enable = true;

  catppuccin = {
    inherit accent flavor;

    enable = true;
  };

  services.dunst.wittano.enable = true;

  desktop.autostart.enable = true;
}
