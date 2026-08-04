{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  options.services.teamviewer.wittano.enable = mkEnableOption "teamviewer";

  config = mkIf config.services.teamviewer.wittano.enable {
    services.teamviewer.enable = true;
    environment.systemPackages = with pkgs; [
      teamviewer
    ];
  };
}
