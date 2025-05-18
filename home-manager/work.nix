{ config, lib, pkgs, ... }:
with lib;
{
  options.profile.work.enable = mkEnableOption "work stuff";

  config = mkIf config.profile.work.enable {
    home.packages = with pkgs; [
      # teams-for-linux # Microsoft Teams
      openfortivpn # VPN
    ];

    desktop.autostart.programs = [
      "teams-for-linux"
    ];
  };
}
