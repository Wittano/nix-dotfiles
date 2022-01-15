{ config, pkgs, ...}:
{
  home.packages = with pkgs; [
    python39Packages.virtualenv
    jetbrains.pycharm-community
  ];
}
