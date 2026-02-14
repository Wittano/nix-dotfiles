{ lib, config, pkgs, ... }: with lib;
let
  cfg = config.programs.signal;
in
{
  options.programs.signal = {
    enable = mkEnableOption "signal";
    package = mkOption {
      description = "Package of signal desktop";
      default = pkgs.signal-desktop;
    };
    enableAutostart = mkEnableOption "signal on autostart";
  };

  config = mkIf cfg.enable {
    home.packages =
      if cfg.enableAutostart
      then [ cfg.package ]
      else [ pkgs.signal-desktop ];

    desktop.autostart.programs = mkIf cfg.enableAutostart [ "signal-desktop --start-in-tray" ];
  };
}
