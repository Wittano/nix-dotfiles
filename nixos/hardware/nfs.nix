{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.samba;

  users = [ "wittano" ];
in
{

  options.hardware.nfs-client.enable = mkEnableOption "Mount NFS devices to system";

  config = mkIf cfg.enable {
    services.gvfs.enable = true;

    environment.systemPackages = [ pkgs.nfs-utils ];

    home-manager.users.wittano.gtk.gtk3.bookmarks = [
      "nfs://wittano.me/mnt/hdd/apps/qbittorrent Qbittorrent"
    ];
  };
}
