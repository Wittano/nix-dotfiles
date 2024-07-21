{ pkgs, lib, unstable, ... }:
with lib;
with lib.my;
let
  fixedSignal = pkgs.signal-desktop.overrideAttrs (oldAttrs: {
    preFixup = oldAttrs.preFixup + ''
      substituteInPlace $out/share/applications/${oldAttrs.pname}.desktop \
      --replace "$out/bin/${oldAttrs.pname}" "$out/bin/${oldAttrs.pname} --use-tray-icon"
    '';
  });
in
{
  autostart = [
    "vivaldi"
    "telegram-desktop"
    "discord"
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
        krusader # Total Commander explorer

        # Apps
        spotify
        unstable.freetube # Youtube desktop
        unstable.joplin-desktop # Notebook
        unstable.vscodium # VS code
        minder # Mind maps
        insomnia # REST API Client
        gnome.pomodoro

        # Security
        bitwarden
        keepassxc

        # Communicator
        telegram-desktop
        fixedSignal # Signal desktop
        element-desktop # matrix communicator
        unstable.discord
        irssi # IRC chat
      ];
    };
  };
}

