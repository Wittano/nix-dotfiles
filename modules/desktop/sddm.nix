{ config, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.sddm;
in
{

  options.modules.desktop.sddm = {
    enable = mkEnableOption "Enable SDDM as display manager";
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = cfg.enable;
      catppuccin = {
        enable = true;
        fontSize = "12";
      };
      autoNumlock = true;
    };
  };
}
