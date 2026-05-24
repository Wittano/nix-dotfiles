{ config, lib, ... }: {
  imports = [
    ./openbox
    ./qtile
    ./xmonad
    ./bspwm.nix
    ./labwc
  ];
}

