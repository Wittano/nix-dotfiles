{ pkgs, lib, unstable, master, ... }:
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
    # "telegram-desktop"
    # "vesktop"
    # "joplin-desktop"
    "spotify"
    # "freetube"
    "gnome-pomodoro"
    "thunderbird"
    "signal-desktop --use-tray-icon --no-sandbox"
  ];

  config = {
    programs.file-roller.enable = true; # Archive explorer
    programs.evince.enable = true; # PDF viever

    nixpkgs.config.permittedInsecurePackages = [
      "electron-27.3.11"
    ];

    home-manager.users.wittano = rec {
      programs.fish.shellAliases.open = "xdg-open";

      programs.mpv.enable = lists.any (x: strings.hasPrefix "streamlink-twitch-gui-bin" (x.name or "")) home.packages;
      home.packages = with pkgs; [
        # Utils
        flameshot

        # Folder Dialog menu
        gnome.zenity

        # Web browser
        vivaldi

        # Utils 
        thunderbird # Mail
        gnome.eog # Image viewer
        onlyoffice-bin # Office staff
        cinnamon.nemo

        # Apps
        spotify
        logseq
        # unstable.joplin-desktop # Notebook
        # unstable.vscodium # VS code
        minder # Mind maps
        # insomnia # REST API Client
        gnome.pomodoro
        unstable.figma-linux # Figma

        # Security
        bitwarden
        keepassxc

        # Social media
        # telegram-desktop
        master.freetube # Youtube desktop
        fixedSignal # Signal desktop
        # element-desktop # matrix communicator
        # vesktop
        unstable.discord
        # irssi # IRC chat
        unstable.streamlink-twitch-gui-bin
      ];
    };
  };
}

