{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  binPath = meta.getExe pkgs.CuboCore.corekeyboard;
in
{
  options.programs.virutal-keyboard.enable = mkEnableOption "virutal-keyboard";
  config = mkIf config.programs.virutal-keyboard.enable {
    assertions = [
      {
        assertion = !config.xsession.enable;
        message = "Virutal keyboard is supported only on Xorg";
      }
    ];

    home.packages = [ pkgs.CuboCore.corekeyboard ];

    desktop.autostart.programs = [ binPath ];
  };
}
