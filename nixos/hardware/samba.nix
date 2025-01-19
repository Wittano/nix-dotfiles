{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.samba;
in
{

  options.hardware.samba.enable = mkEnableOption "Mount Samba device to system";

  config = mkIf cfg.enable {
    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [ cifs-utils ];

    home-manager.users = desktop.mkMultiUserHomeManager [ "wittano" "wito" ] {
      gtk.gtk3.bookmarks = [
        "file:///mnt/samba Remote Home"
      ];
    };

    fileSystems."/mnt/samba" = {
      device = "//192.168.1.5/samba/wittano";
      fsType = "cifs";
      options = [
        "credentials=${config.age.secrets.samba.path}"
        "uid=${builtins.toString config.users.users.wittano.uid}"
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
        "user"
        "users"
      ];
    };
  };
}
