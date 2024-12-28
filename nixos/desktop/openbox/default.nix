{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.desktop.openbox;

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
{
  options.desktop.openbox = {
    enable = mkEnableOption "openbox config";
    users = mkOption {
      description = "List of users that use desktop configuration";
      type = with types; listOf str;
    };
  };

  config = mkIf config.desktop.openbox.enable {
    assertions = desktop.mkDesktopAssertion config cfg.users;

    home-manager.users = desktop.mkMultiUserHomeManager cfg.users {
      desktop.autostart = {
        desktopName = "openbox";
        scriptPath = ".config/openbox/autostart";
        programs = [ "tint2" "volumeicon" ];
      };
      home = {
        packages = with pkgs; [
          openbox-menu
          lxmenu-data
          obconf
          volumeicon
          tint2
          # Utils
          arandr
        ];
        file = themes;
      };
      xdg.configFile = {
        "openbox/menu.xml".source = ./menu.xml;
        "openbox/rc.xml".source = ./rc.xml;
        "tint2".source = ./tint2;
      };
    };

    services.xserver = {
      enable = true;
      windowManager.openbox.enable = true;
    };
  };
}
