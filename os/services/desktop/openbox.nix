{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    rofi
    openbox-menu
    lxmenu-data
    obconf
    polybar

    # Utils
    arandr
    lxappearance
    nitrogen
  ];
}
