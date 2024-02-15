{ cfg, pkgs, lib, home-manager, dotfiles, ... }:
with lib;
with lib.my;
let
  catpuccinTheme = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "rofi";
    rev = "5350da41a11814f950c3354f090b90d4674a95ce";
    sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
  };
in
{
  home-manager.users.wittano = {
    home = {
      packages = with pkgs; [ rofi ];

      activation.linkMutableRofiConfig =
        link.createMutableLinkActivation cfg "rofi";

      file.".local/share/rofi/themes".source =
        builtins.toPath "${catpuccinTheme}/basic/.local/share/rofi/themes";
    };

    xdg.configFile = mkIf (cfg.enableDevMode == false) {
      rofi.source = dotfiles.rofi.source;
    };
  };
}
