{ lib, config, ... }: with lib;
let
  cfg = config.programs.discord.wittano;

  discordExe =
    if cfg.type == "discord"
    then meta.getExe programs.discord.package
    else if cfg.type == "vesktop" then meta.getExe programs.vesktop.package
    else throw "Unknown Discord client configuration ${cfg.type}";
in
{
  options.programs.discord.wittano = {
    enable = mkEnableOption "discord";
    type = mkOption {
      type = types.enum [ "discord" "vesktop" ];
      default = "discord";
      description = "Choice Discord client. By default is official Discord client without any modification";
    };
    enableAutostart = mkEnableOption "discord autostart";
  };

  config = mkIf cfg.enable {
    programs.vesktop.enable = cfg.type == "vesktop";
    programs.discord.enable = cfg.type == "discord";

    desktop.autostart.programs = mkIf cfg.enableAutostart [ "${discordExe} --start-minimized" ];
  };
}
