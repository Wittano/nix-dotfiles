{ pkgs, lib, home-manager, dotfiles, cfg, ... }:
with lib;
with lib.my;
with builtins;
{
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ tint2 ];
      activation.linkMutableTint2Config = link.createMutableLinkActivation cfg "tint2";
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      tint2.source = dotfiles.tint2.source;
    };
  };

}

