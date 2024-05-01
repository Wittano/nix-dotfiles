{ pkgs, lib, ... }:
with lib;
with lib.my;
{
  config = {
    # TODO add new custom theme for Qt apps
    qt = {
      enable = true;
      style = "adwaita-dark";
    };

    environment.systemPackages = with pkgs.libsForQt5; [ breeze-icons ];
  };
}
