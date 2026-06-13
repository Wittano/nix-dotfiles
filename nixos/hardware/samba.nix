{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.samba.wittano;

  sambaGroupName = "samba";
  users = [ "wittano" ];
  extraGroups =
    if users != [ ] then
      builtins.listToAttrs
        (builtins.map
          (x: { name = x; value = { extraGroups = [ sambaGroupName ]; }; })
          users) else { };
in
{

  options.hardware.samba.wittano = {
    mountAsSystem = mkEnableOption "Mount Samba device to system";
    onlyBookmarks = mkEnableOption "Add Samaba Homelab share dictionary as a GTK bookmark";
  };

  config = {
    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [ cifs-utils ];

    home-manager.users = desktop.mkMultiUserHomeManager users {
      gtk.gtk3.bookmarks =
        let
          remoteHomelab = lists.optional cfg.onlyBookmarks "smb://wittano.me/wittano TrueNAS";
          mountedHomelab = lists.optional cfg.mountAsSystem "file:///mnt/samba TrueNAS";
        in
        remoteHomelab ++ mountedHomelab;
    };

    users = mkIf cfg.mountAsSystem {
      users = extraGroups;
      groups.samba.gid = 988;
    };

    fileSystems = mkIf cfg.mountAsSystem {
      "/mnt/samba" = {
        device = "//wittano.me/wittano";
        fsType = "cifs";
        options = [
          "credentials=${config.age.secrets.samba.path}"
          "uid=${builtins.toString config.users.users.wittano.uid}"
          "gid=${sambaGroupName}"
          "x-systemd.automount"
          "noauto"
          "x-systemd.idle-timeout=60"
          "x-systemd.device-timeout=5s"
          "x-systemd.mount-timeout=5s"
          "user"
          "file_mode=0774"
          "dir_mode=0774"
          "rw"
          "users"
        ];
      };
    };
  };
}
