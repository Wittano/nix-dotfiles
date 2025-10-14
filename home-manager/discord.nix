{ lib, config, pkgs, ... }: with lib;
let
  cfg = config.programs.discord;
  exeName = meta.getExe cfg.package;
in
{
  options.programs.discord = {
    enable = mkEnableOption "discord";
    package = mkOption {
      default = pkgs.vesktop;
      description = "discord client";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    desktop.autostart.programs = [ "${exeName} --start-minimized" ];
  };
}
