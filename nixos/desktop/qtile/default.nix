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
    };
  };

  config = mkIf config.desktop.qtile.enable {
    fonts.packages = with pkgs; [ nerdfonts jetbrains-mono ];


    home-manager.users = desktop.mkMultiUserHomeManager cfg.users {
      desktop.autostart.desktop = [{
        name = "qtile";
      }];

      xdg.configFile."qtile".source = ./.;
    };
    services.xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
