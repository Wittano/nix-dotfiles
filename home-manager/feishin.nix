{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  options.programs.feishin = {
    enable = mkEnableOption "feishin";
    enableAutostart = mkEnableOption "feishin on autostart";
  };

  config = mkIf config.programs.feishin.enable {
    home.packages = [ pkgs.feishin ];

    desktop.autostart.programs = mkIf config.programs.feishin.enableAutostart [ "feishin" ];
  };
}
