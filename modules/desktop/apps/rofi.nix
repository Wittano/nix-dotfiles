{ config, pkgs, lib, configDir, home-manager, mainUser, ... }:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.desktop.apps.rofi;
in {
  options.modules.desktop.apps.rofi = {
    enable = mkEnableOption "Enable rofi";
  };

  config = mkIf cfg.enable {
    home-manager.users."${mainUser}".home = {
      packages = with pkgs; [ rofi ];
      xdg.configFile."rofi" = "${configDir}/rofi";
    };
  };
}
