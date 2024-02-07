{ config, lib, pkgs, privateRepo, home-manager, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.themes.catppuccin;
  catppuccinQtTheme = mapper.mapDirToAttrs (pkgs.fetchFromGitHub {
    repo = "qt5ct";
    owner = "catppuccin";
    rev = "89ee948e72386b816c7dad72099855fb0d46d41e";
    sha256 = "sha256-t/uyK0X7qt6qxrScmkTU2TvcVJH97hSQuF0yyvSO/qQ=";
  });
in
{
  options = {
    modules.themes.catppuccin = {
      enable = mkEnableOption ''
        Enable catppuccin theme as system theme
      '';
    };
  };

  # TODO update module with fetures:
  # - update theme for other applications
  # - update QT and GTK system theme
  config = mkIf (cfg.enable) {
    environment.systemPackages =
      [ pkgs.catppuccin-gtk privateRepo.catppuccin-icon-theme ];
  };
}
