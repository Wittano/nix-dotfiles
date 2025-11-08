{ config, lib, ... }: {
  assertions = [{
    assertion =
      let
        enabledDesktops = lib.attrsets.filterAttrs (_: v: v.enable or false) config.desktop;
        enabledDesktopNames = lib.attrsets.mapAttrsToList (n: _: n) enabledDesktops;
      in
      builtins.length enabledDesktopNames == 1;
    message = "You cannot run more then one desktop module at the same time";
  }];

  imports = [
    ./openbox
    ./qtile
    ./xmonad
    ./bspwm.nix
  ];
}

