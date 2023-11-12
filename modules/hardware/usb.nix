{ config, pkgs, ... }:
let
  mountUSBScript = pkgs.writeScriptBin "mount.sh" ''
    ${pkgs.udisks2}/bin/udisksctl mount -b "/dev/$2"
  '';
  unmountUSBScript = pkgs.writeScriptBin "unmount.sh" ''
    ${pkgs.udisks2}/bin/udisksctl unmount -b "/dev/$2"
  '';
in
{
  config = {
    environment.systemPackages = with pkgs; [ polkit_gnome ];

    services.udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    services.devmon.enable = true;
    services.gvfs.enable = true;

    programs.gnome-disks.enable = config.modules.desktop.gnome.enable;
  };
}
