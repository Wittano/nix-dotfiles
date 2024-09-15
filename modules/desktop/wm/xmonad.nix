{ config, isDevMode, lib, dotfiles, hostname, pkgs, unstable, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode hostname dotfiles;

  name = "xmonad";
  apps = [
    "feh"
    "gtk"
    "qt"
    "dunst"
    "picom"
    "tmux"
    "bluetooth"
    "kitty"
    "superfile"
    "rofi"
    "notify"
  ];
  extraConfig = {
    services.xserver = {
      enable = true;
      windowManager.session = [{
        name = "xmonad";
        start = ''
          systemd-cat -t xmonad -- ${config.home-manager.users.wittano.xsession.windowManager.command} &
          waitPID=$!
        '';
      }];
    };

    home-manager.users.wittano = {
      programs.xmobar = {
        enable = true;
        package = unstable.xmobar;
        extraConfig = mkIf (isDevMode) (builtins.readFile dotfiles.xmonad.xmobarrc.source);
      };

      xsession.windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        haskellPackages = unstable.haskellPackages;
        config = dotfiles.xmonad.src."Main.hs".source;
        libFiles = trivial.pipe dotfiles.xmonad.src [
          (attrsets.filterAttrs (n: v: builtins.typeOf v == "set" && strings.hasPrefix "Main" n == false))
          (builtins.mapAttrs (n: v: pkgs.writeText n (builtins.readFile v.source)))
        ];
      };
    };

    modules.dev.lang.ides = [ "haskell" ];
  };
}
