{ config, lib, ... }:
with lib;
{
  options.programs.nh.wittano.enable = mkEnableOption "nh program";

  config = mkIf config.programs.nh.wittano.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 7d";
        dates = "19:00";
      };
    };
  };
}
