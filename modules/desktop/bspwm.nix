{ config, pkgs, lib, dotfiles, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.bspwm;
  importApp = name:
    apps.importApp cfg name;

  nitrogenConfig = importApp "nitrogen";
  alacrittyConfig = importApp "alacritty";
  rofiConfig = importApp "rofi";
  tmuxConfig = importApp "tmux";
  picomConfig = importApp "picom";
  switchOffScript = pkgs.callPackage ./utils/switch-off.nix { };
in
{

  options.modules.desktop.bspwm = {
    enable = mkEnableOption "Enable BSPWM desktop";
    enableDevMode = mkEnableOption ''
      Enable dev mode.
      Special mode, that every external configuration will be mutable
    '';
  };

  config = mkIf cfg.enable (mkMerge [
    rofiConfig
    picomConfig
    alacrittyConfig
    tmuxConfig
    nitrogenConfig
    {
      home-manager.users.wittano = {
        home = {
          packages = with pkgs; [
            polybar
            gsimplecal
            notify-osd-customizable
            notify-desktop
            wmname
            rofi

            # Utils
            lxappearance

            font-awesome
            font-awesome_5
            siji
            switchOffScript
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
              linkMutableBspwmConfig = customeActivation ".config/bspwm";
              linkMutableSxhkdConfig = customeActivation ".config/sxhkd";
              linkMutablePolybarConfig = customeActivation ".config/polybar";
            };
        };

        xdg.configFile =
          let configDir = dotfiles.".config";
          in mkIf (cfg.enableDevMode == false) {
            bspwm.source = configDir.bspwm.source;
            sxhkd.source = configDir.sxhkd.source;
            polybar.source = configDir.polybar.source;
          };
      };

      services = {
        xserver = {
          enable = true;
          windowManager.bspwm.enable = true;
        };
      };
    }
  ]);

}
