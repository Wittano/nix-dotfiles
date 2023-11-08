{ config, pkgs, lib, dotfiles, unstable, username ? "wittano", ownPackages, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.qtile;
  importApp = name:
    apps.importApp cfg name;

  nitrogenConfig = importApp "nitrogen";
  alacrittyConfig = importApp "alacritty";
  rofiConfig = importApp "rofi";
  tmuxConfig = importApp "tmux";
  xautolockConfig = importApp "xautolock";
in
{

  options.modules.desktop.qtile = {
    enable = mkEnableOption "Enable Qtile desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf (cfg.enable) (mkMerge [
    rofiConfig
    alacrittyConfig
    tmuxConfig
    xautolockConfig
    nitrogenConfig
    {
      home-manager.users."${username}" = {
        home = {
          packages =
            let
              switchOff = pkgs.callPackage ./utils/switch-off.nix { };
            in
            with pkgs; [
              notify-osd-customizable
              notify-desktop

              # Utils
              lxappearance
              switchOff
            ];

          activation =
            let
              customeActivation = path:
                link.createMutableLinkActivation {
                  internalPath = path;
                  isDevMode = cfg.enableDevMode;
                };
            in
            {
              linkMutableQtileConfig = customeActivation ".config/qtile";
            };
        };

        xdg.configFile =
          let configDir = dotfiles.".config";
          in mkIf (cfg.enableDevMode == false) {
            qtile.source = configDir.qtile.source;
          };

      };

      services.xserver = {
        enable = true;

        windowManager.qtile.enable = true;
      };
    }
  ]);

}
