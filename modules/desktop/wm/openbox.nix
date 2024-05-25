{ config, pkgs, lib, dotfiles, isDevMode, hostname, ... }:
with lib;
with lib.my;
let
  catppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "openbox";
    rev = "56b996e2118bfe55492b9e4febb129af51e476a2";
    sha256 = "sha256-5Hx/qn5LV7zdicJu9k3fHSuBoIMryNu6s3hkosQrMVw=";
  };

  themes = trivial.pipe catppuccin [
    builtins.readDir
    (attrsets.filterAttrs (n: v: strings.hasPrefix "Catppuccin" n && v == "directory"))
    (attrsets.mapAttrs' (n: _: {
      name = ".themes/${n}";
      value = {
        source = catppuccin + "/${n}";
      };
    }))
  ];
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
    "picom"
    "kitty"
    "rofi"
    "tmux"
    "gtk"
    "dunst"
  ];
  installAutostartFile = false;
  autostart = [ "tint2" "volumeicon" ];
  autostartPath = "openbox/autostart";
  extraConfig = {
    home-manager.users.wittano = {
      home = {
        packages = with pkgs; [
          openbox-menu
          lxmenu-data
          obconf
          tint2
          # Utils
          arandr
        ];
        file = themes;
      };
    };

    services.xserver = {
      enable = true;
      windowManager.openbox.enable = true;
    };
  };
}

