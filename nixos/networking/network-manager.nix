{ lib, config, pkgs, ... }:
with lib;{
  options.networking.networkmanager.wittano.enable = mkEnableOption "Network Manager";

  config = mkIf config.networking.networkmanager.wittano.enable {
    environment.systemPackages = with pkgs; [ networkmanagerapplet dmenu networkmanager_dmenu ];
    programs.nm-applet.enable = true;
    services.pppd.enable = true;
    networking.networkmanager = {
      enable = true;
      plugins = with pkgs;[
        networkmanager-fortisslvpn
      ];
      dhcp = "dhcpcd";
    };
  };
}
