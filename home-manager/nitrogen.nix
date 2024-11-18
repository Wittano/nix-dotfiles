{ config, pkgs, lib, ... }:
with lib;
with lib.my;
{
  options.programs.nitrogen.wittano.enable = mkEnableOption "Enable custom kitty config";

  config = mkIf config.programs.nitrogen.wittano.enable {
    desktop.autostart.programs = [ "nitrogen --restore" ];

    home.packages = with pkgs; [ nitrogen ];
  };
}
