{ lib, config, ... }: with lib;
let
  cfg = config.programs.discord.wittano;
in
{
  options.programs.discord.wittano = {
    enable = mkEnableOption "discord";
    enableAutostart = mkEnableOption "discord autostart";
  };

  config = mkIf cfg.enable {
    programs.vesktop.enable = true;

    desktop.autostart.programs = mkIf cfg.enableAutostart [ "vesktop --start-minimized" ];
  };
}
