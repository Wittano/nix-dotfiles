{ config, pkgs, lib, username, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.flatpak;
in
{
  options = {
    modules.services.flatpak = { enable = mkEnableOption "Enable flatpak"; };
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals =
        lib.mkIf (config.services.xserver.desktopManager.gnome.enable == false)
          [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "*";
    };


    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';
  };

}
