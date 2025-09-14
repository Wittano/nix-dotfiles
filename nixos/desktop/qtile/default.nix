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
  };

  config = mkIf config.desktop.qtile.enable {
    fonts.packages = with pkgs; [ nerd-fonts.hack font-awesome jetbrains-mono ];

    home-manager.users = desktop.mkMultiUserHomeManager cfg.users {
      xdg.configFile."qtile".source = ./.;
      programs = {
        jetbrains.ides = [ "python" ];
        rofi.wittano = {
          enable = true;
          desktopName = "qtile";
        };
      };
    };

    environment.variables.QTILE_THEME = "catppuccin_${config.catppuccin.flavor}";

    services.xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
