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
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    desktop.autostart.programs = [ "signal-desktop --start-in-tray" ];
  };
}
