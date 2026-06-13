{ config, pkgs, lib, ... }:
with lib;
with lib.my;
{
  options.hardware.nfs-client.enable = mkEnableOption "Mount NFS devices to system";

  config = mkIf config.hardware.nfs-client.enable {
    services.gvfs.enable = true;

    environment.systemPackages = [ pkgs.nfs-utils ];

    home-manager.users.wittano.gtk.gtk3.bookmarks = [
      "nfs://wittano.me/mnt/hdd/apps/qbittorrent Qbittorrent"
    ];
  };
}
