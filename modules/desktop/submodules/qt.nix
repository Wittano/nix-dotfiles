{ pkgs, lib, ... }:
with lib;
with lib.my;
{
  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs.libsForQt5; [ breeze-icons ];
}
