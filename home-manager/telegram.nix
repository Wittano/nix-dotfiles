{ lib, config, pkgs, ... }: with lib; {
  options.programs.telegram = {
    enable = mkEnableOption "telegram";
    enableAutostart = mkEnableOption "telegram on autostart";
  };

  config = mkIf config.programs.telegram.enable {
    home.packages = [ pkgs.telegram-desktop ];

    desktop.autostart.programs = mkIf config.programs.telegram.enableAutostart [ "telegram-desktop -startintray" ];
  };
}
