{ cfg, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
{
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ rofi ];

      activation.linkMutableRofiConfig =
        link.createMutableLinkActivation {
          internalPath = ".config/rofi";
          isDevMode = cfg.enableDevMode;
        };
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      rofi.source = dotfiles.".config".rofi.source;
    };
  };
}
