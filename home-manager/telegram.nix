{ lib, config, pkgs, ... }: with lib; {
  options.programs.telegram.enable = mkEnableOption "telegram";

  config = mkIf config.programs.telegram.enable {
    home.packages = [ pkgs.telegram-desktop ];

    desktop.autostart.programs = [ "telegram-desktop -startintray" ];
  };
}
