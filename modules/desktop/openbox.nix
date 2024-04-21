{ config, pkgs, lib, dotfiles, isDevMode, ... }:
with lib;
with lib.my;
desktop.mkDesktopModule {
  inherit config isDevMode;

  name = "openbox";
  mutableSources = {
    ".config/openbox" = dotfiles.openbox.source;
    ".config/tint2" = dotfiles.tint2.source;
  };
  desktopApps = [
    "nitrogen"
    "kitty"
    "rofi"
    "gtk"
    "xautolock"
    "dunst"
  ];
  extraConfig = {
    home-manager.users.wittano.home.packages = with pkgs; [
      openbox-menu
      lxmenu-data
      obconf
      volumeicon
      gsimplecal
      tint2

      # Utils
      arandr
    ];

    services.xserver = {
      enable = true;
      windowManager.openbox.enable = true;
    };
  };
}
# let
#   cfg = config.modules.desktop.openbox;
#   desktopApps = desktop.mkAppsSet { inherit config cfg; name = "openbox"; };

# devMode = desktop.mkDevMode config cfg {
#   ".config/openbox" = dotfiles.openbox.source;
#   ".config/tint2" = dotfiles.tint2.source;
# };
# in
# {
#   options.modules.desktop.openbox = desktop.mkDesktopOption { inherit devMode; };

#   config = mkIf cfg.enable (mkMerge (with desktopApps; [
# nitrogen
# kitty
# rofi
# gtk
# xautolock
# dunst
#     devMode.config
#     {
#       home-manager.users.wittano.home.packages = with pkgs; [
#         openbox-menu
#         lxmenu-data
#         obconf
#         volumeicon
#         gsimplecal
#         tint2

#         # Utils
#         arandr
#       ];

#       services.xserver = {
#         enable = true;
#         windowManager.openbox.enable = true;
#       };
#     }
#   ]));

# }
