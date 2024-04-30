{ pkgs, lib, config, unstable, desktopName, ... }:
with lib;
with builtins;
let
  cfg = config.modules.desktop.apps;
  autostartDesktopModule = attrsets.optionalAttrs (desktopName != "") {
    modules.desktop.${desktopName}.autostartPrograms = [
      "vivaldi"
      "telegram-desktop"
      "discord"
      "spotify"
      "freetube"
      "signal-desktop --use-tray-icon --no-sandbox"
      "gnome-pomodoro"
    ];
  };
in
{
  options = {
    modules.desktop.apps = {
      enable = mkEnableOption "Install desktop applications";
    };
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
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
          soundux
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
    }
    autostartDesktopModule
  ]);
}

