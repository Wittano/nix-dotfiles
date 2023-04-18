{ config, pkgs, lib, unstable, ... }:
with lib.my;
let
  programs = with pkgs; [
    # Utils
    flameshot

    # Web browser
    vivaldi

    # Apps
    thunderbird
    gnome.file-roller
    keepassxc
    gnome.eog
    spotify
    evince
    pcmanfm

    # Dev
    vscodium
  ];
in
{
  home = {
    username = "wittano";
    homeDirectory = "/home/wittano";
    packages = programs;
    activation.fixOpenLinksFromFlatpakApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.systemd}/bin/systemctl --user import-environment PATH
      ${pkgs.systemd}/bin/systemctl --user restart xdg-desktop-portal.service
    '';
  };
}
