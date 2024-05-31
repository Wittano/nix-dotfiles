{ pkgs, lib, unstable, ... }:
with lib;
with lib.my;
{
  autostart = [
    "vivaldi"
    "telegram-desktop"
    "discord --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy"
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
      home.packages = with pkgs; [
        # Utils
        flameshot
        kazam

        # Web browser
        unstable.vivaldi

        # Utils 
        thunderbird # Mail
        gnome.eog # Image viewer
        onlyoffice-bin # Office staff
        vesktop
        figma-linux # Figma
        cinnamon.nemo # File explorer

        # Apps
        spotify
        unstable.freetube # Youtube desktop
        streamlink-twitch-gui-bin # Twitch desktop
        mpv
        joplin-desktop # Notebook
        vscodium
        tor-browser # Tor
        minder # Mind maps
        insomnia # REST API Client
        mongodb-compass # MongoDB desktop client
        gnome.pomodoro

        # Security
        bitwarden
        keepassxc

        # Communicator
        telegram-desktop
        signal-desktop
        element-desktop # matrix communicator
        discord
      ];
    };
  };
}

