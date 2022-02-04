{ config, pkgs, home-manager, ... }: {
  home-manager.users.wittano.home.packages = with pkgs; [
    steam
    steam-run-native
    lutris
  ];
}
