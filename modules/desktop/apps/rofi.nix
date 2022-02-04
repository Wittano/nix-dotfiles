{ config, pkgs, lib, home-manager, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.apps.rofi;
in {
  options.modules.desktop.apps.rofi = {
    enable = mkEnableOption "Enable rofi";
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano = {
      home.packages = with pkgs; [ rofi ];

      xdg.configFile.rofi.source = path.getConfigFile "rofi";
    };
  };
}
