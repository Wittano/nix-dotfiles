{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.hardware.samba;

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

  options.hardware.samba.enable = mkEnableOption "Mount Samba device to system";

  config = mkIf cfg.enable {
    services.gvfs.enable = true;

    environment.systemPackages = with pkgs; [ cifs-utils ];

    home-manager.users = desktop.mkMultiUserHomeManager users {
      gtk.gtk3.bookmarks = [
        "file:///mnt/samba Remote Home"
      ];
    };

    users = {
      users = extraGroups;
      groups.samba.gid = 988;
    };

    fileSystems."/mnt/samba" = {
      device = "//192.168.1.5/wittano";
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
}
