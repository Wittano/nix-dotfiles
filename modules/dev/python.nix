{ config, pkgs, ...}:
{
  home.packages = with pkgs; [
    virtualenv
    jetbrains.pycharm-community
  ];
}
