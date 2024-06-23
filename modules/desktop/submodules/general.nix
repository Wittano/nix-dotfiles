{ pkgs, lib, unstable, ... }:
with lib;
with lib.my;
{
  autostart = [
    "vivaldi"
    "telegram-desktop"
    "vesktop"
    "spotify"
    "freetube"
    "gnome-pomodoro"
    "thunderbird"
    "signal-desktop --use-tray-icon --no-sandbox"
  ];

  config = {
    programs.file-roller.enable = true; # Archive explorer
    programs.evince.enable = true; # PDF viever

    home-manager.users.wittano = {
      programs.fish.shellAliases.open = "xdg-open";

      programs.mpv = {
        enable = true;
        catppuccin.enable = true;
      };

      home.packages = with pkgs; [
        # Utils
        flameshot

        # Folder Dialog menu
        gnome.zenity

        # Web browser
        unstable.vivaldi

        # Utils 
        thunderbird # Mail
        gnome.eog # Image viewer
        onlyoffice-bin # Office staff
        cinnamon.nemo # File explorer

        # Apps
        spotify
        unstable.freetube # Youtube desktop
        joplin-desktop # Notebook
        vscodium
        minder # Mind maps
        insomnia # REST API Client
        gnome.pomodoro

        # Security
        bitwarden
        keepassxc

        # Communicator
        telegram-desktop
        signal-desktop
        element-desktop # matrix communicator
        unstable.vesktop # Discord with linux patches
      ];
    };
  };
}

