{ config, pkgs, ... }: {
  services.picom = {
    enable = true;
    fade = false;
  };

  environment.systemPackages = with pkgs; [
    rofi
    openbox-menu
    lxmenu-data
    obconf
    polybar
    tint2
    volumeicon
    gsimplecal
    notify-osd-customizable

    # Utils
    arandr
    lxappearance
    nitrogen
  ];
}
