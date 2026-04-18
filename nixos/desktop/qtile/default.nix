{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.desktop.qtile;
in
{
  options.desktop.qtile = {
    enable = mkEnableOption "qtile desktop";
    users = mkOption {
      description = "List of users that use desktop configuration";
      type = with types; listOf str;
      default = [ "wittano" ];
    };
    profile = mkOption {
      type = types.enum [ "LAPTOP" "PC" ];
      default = "PC";
      description = "Qtile profile";
    };
  };

  config = mkIf config.desktop.qtile.enable {
    fonts.packages = with pkgs; [ nerd-fonts.hack font-awesome jetbrains-mono ];

    home-manager.users = desktop.mkMultiUserHomeManager cfg.users {
      xdg.configFile."qtile".source = ./.;
      desktop.autostart.enable = true;
      programs = {
        nitrogen.wittano.enable = true;
        jetbrains.ides = [ "python" ];
        rofi.wittano = {
          enable = true;
          desktopName = "qtile";
        };
      };
      services = {
        redshift.wittano.enable = true;
        picom.wittano.enable = true;
      };
      home.packages = with pkgs; [ flameshot ];
    };

    environment.variables = {
      QTILE_THEME = "catppuccin_${config.catppuccin.flavor}";
      QTILE_PROFILE = config.desktop.qtile.profile;
    };

    services.xserver = {
      enable = true;
      windowManager.qtile = {
        enable = true;
        extraPackages = pyPkgs: with pyPkgs; [
          psutil
        ];
      };
    };
  };
}
