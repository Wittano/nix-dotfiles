{ config, pkgs, lib, dotfiles, isDevMode, hostname, ... }:
with lib;
with lib.my;
let
  draculaOpenbox = pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "openbox";
    rev = "b3222509bb291dc62d201a66a1547a7aac0040b3";
    sha256 = "sha256-GZ6/ThHBP3TZshDPHdsNjQEpqowt4eqva0MI/mzELRg=";
  };
  draculaIcon = pkgs.fetchzip {
    url = "https://github.com/dracula/gtk/files/5214870/Dracula.zip";
    sha256 = "sha256-rcSKlgI3bxdh4INdebijKElqbmAfTwO+oEt6M2D1ls0=";
  };
in
desktop.mkDesktopModule {
  inherit config isDevMode hostname dotfiles;

  name = "openbox";
  mutableSources = {
    ".config/openbox/menu.xml" = dotfiles.openbox."menu.xml".source;
    ".config/openbox/rc.xml" = dotfiles.openbox."rc.xml".source;
    ".config/tint2" = dotfiles.tint2.source;
  };
  apps = [
    "bluetooth"
    "nitrogen"
    "kitty"
    "rofi"
    "gtk"
    "xautolock"
    "dunst"
  ];
  installAutostartFile = false;
  # TODO Update config
  extraConfig = { activationPath, ... }: {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [
          openbox-menu
          lxmenu-data
          obconf
          volumeicon
          gsimplecal
          tint2
          # Utils
          arandr
        ];
        file = {
          ".themes/Dracula-withoutBorder".source = draculaOpenbox + "/Dracula-withoutBorder";
          ".icons/dracula".source = draculaIcon;
        };
      };

      xdg.configFile."openbox/autostart".source = activationPath;
    };

    environment.systemPackages = with pkgs; [ dracula-theme ];

    services.xserver = {
      enable = true;
      windowManager.openbox.enable = true;
    };
  };
}

