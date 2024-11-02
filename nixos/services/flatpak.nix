{ config, pkgs, lib, ... }:
with lib;
{
  options.services.flatpak.wittano.enable = mkEnableOption "Enable flatpak";

  config = mkIf config.services.flatpak.wittano.enable {
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = mkIf (config.services.xserver.desktopManager.gnome.enable == false)
        [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };

    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';
  };
}
