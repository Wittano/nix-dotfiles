{ pkgs, lib, config, unstable, home-manager, ... }:
with lib;
with builtins;
let
  cfg = config.modules.desktop.apps;
in
{
  options = {
    modules.desktop.apps = {
      enable = mkEnableOption "Install desktop applications";
    };
  };

  config = mkIf (cfg.enable) {
    home-manager.users.wittano.home.packages = with pkgs; [
      # Utils
      flameshot
      kazam

      # Web browser
      vivaldi

      # Utils 
      thunderbird
      gnome.eog
      evince
      onlyoffice-bin
      soundux
      figma-linux

      # Apps
      spotify
      unstable.freetube # Youtube desktop
      streamlink-twitch-gui-bin # Twitch desktop
      mpv
      joplin-desktop
      vscodium

      # Security
      bitwarden
      keepassxc

      # Communicator
      telegram-desktop
      signal-desktop
      discord
    ];
  };
}

