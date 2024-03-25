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
    programs.file-roller.enable = true; # Archive explorer
    programs.evince.enable = true; # PDF viever

    home-manager.users.wittano = {
      programs.fish.shellAliases.open = "xdg-open";
      home.packages = with pkgs; [
        # Utils
        flameshot
        kazam

        # Web browser
        vivaldi

        # Utils 
        thunderbird # Mail
        gnome.eog # Image viewer
        onlyoffice-bin # Office staff
        soundux
        figma-linux # Fi
        cinnamon.nemo # File explorer

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
        element-desktop # matrix communicator
        discord
      ];
    };
  };
}

