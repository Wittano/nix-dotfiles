{ inputs, systemVersion, master, pkgs, accent ? "pink", flavor ? "latte", desktopName ? "xmonad", ... }: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nixvim.homeManagerModules.nixvim
    ./../home-manager
  ];

  home = {
    stateVersion = systemVersion;
    packages = with pkgs; [
      # Utils
      flameshot # Screenshot
      textsnatcher # Text extractor
      czkawka # File duplication cleaner
      szyszka # File renamer

      # Folder Dialog menu
      zenity

      # Web browser
      vivaldi

      # Utils 
      eog # Image viewer
      libreoffice # Office staff
      nemo # File explorer
      pandoc # Text file converter

      # Apps
      keepassxc # Password manager
      gnome-pomodoro # Pomodoro
      todoist-electron # ToDo app
      joplin-desktop # Notebook
      xournalpp # Handwritten notebook

      # Security
      bitwarden
      keepassxc
    ];
  };

  programs = {
    fish.functions.download-yt.body = "${pkgs.parallel}/bin/parallel ${master.yt-dlp}/bin/yt-dlp -P /mnt/samba/youtube --progress ::: $argv";
    thunderbird.wittano.enable = true;
    git.wittano.enable = true;
    btop.enable = true;
    kitty.wittano.enable = true;
    fish = {
      wittano = {
        enable = true;
        enableDirenv = true;
      };
      shellAliases.open = "xdg-open";
    };
    nitrogen.wittano.enable = true;
    rofi.wittano = {
      inherit desktopName;

      enable = true;
    };
    neovim.wittano.enable = true;
  };

  qt.wittano.enable = true;
  gtk.wittano.enable = true;

  catppuccin = {
    inherit accent flavor;

    enable = true;
  };

  services = {
    redshift.wittano.enable = true;
    betterlockscreen.wittano.enable = true;
    picom.wittano.enable = true;
    dunst.wittano.enable = true;
  };

  desktop.autostart = {
    enable = true;
    programs = [
      "gnome-pomodoro"
      "vivaldi"
      "signal-desktop --start-in-tray"
      "todoist-electron"
    ];
  };
}
