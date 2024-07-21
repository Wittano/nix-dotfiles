{ config, isDevMode, lib, dotfiles, hostname, pkgs, unstable, ... }:
with lib;
with lib.my;
let
  haskellPackages = unstable.haskellPackages.extend (self: super: {
    xmonad = self.callHackage "xmonad" "0.18.0" { };
    xmonad-contrib = assert unstable.haskellPackages.xmonad-contrib.version == "0.18.0";
      (self.callHackage "xmonad-contrib" "0.18.0" { }).overrideAttrs {
        patches = [ ./../patches/xmonad-contrib.patch ];
      };
    xmonad-extras = assert unstable.haskellPackages.xmonad-extras.version == "0.17.1";
      (self.callHackage "xmonad-extras" "0.17.1" { }).overrideAttrs {
        patches = [ ./../patches/xmonad-extras.patch ];
      };
  });
in
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
  ];
  mutableSources = {
    ".config/xmonad/xmobarrc" = dotfiles.xmonad.xmobarrc.source;
  };
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
        inherit haskellPackages;

        enable = true;
        enableContribAndExtras = true;
        # extraPackages = self: [ self.containers_0_7 ];
        config = dotfiles.xmonad.src."Main.hs".source;
        libFiles = trivial.pipe dotfiles.xmonad.src [
          (attrsets.filterAttrs (n: v: builtins.typeOf v == "set" && strings.hasPrefix "Main" n == false))
          (builtins.mapAttrs (n: v: pkgs.writeText n (builtins.readFile v.source)))
        ];
      };
    };

    environment.systemPackages = with pkgs; [ cabal-install ];

    modules.dev.lang.ides = [ "haskell" ];
  };
}
