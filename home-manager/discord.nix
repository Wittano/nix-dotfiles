{ lib, config, ... }: with lib;
let
  cfg = config.programs.discord.wittano;
in
{
  options.programs.discord.wittano = {
    enable = mkEnableOption "discord";
  };

  config = mkIf cfg.enable {
    programs.vesktop.enable = true;

    desktop.autostart.programs = [ "vesktop --start-minimized" ];
  };
}
