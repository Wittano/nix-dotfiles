{ pkgs, home-manager, lib, dotfiles, cfg, ... }:
with lib;
with lib.my; {
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ kitty ];
      activation.linkMutableKittyConfig =
        link.createMutableLinkActivation cfg ".config/kitty";
    };

    programs.fish.shellAliases.ssh = "kitty +kitten ssh";

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      "kitty".source = dotfiles.".config".kitty.source;
    };
  };
}
