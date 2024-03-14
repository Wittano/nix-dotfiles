{ config, pkgs, ... }: {
  config = {
    services.udisks2 = {
      enable = true;
      mountOnMedia = true;
    };

    services.devmon.enable = true;
    services.gvfs.enable = true;

    programs.gnome-disks.enable = config.modules.desktop.gnome.enable;
  };
}
