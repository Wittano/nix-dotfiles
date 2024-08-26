{ lib, config, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming.minecraft;
  gamingCfg = config.modules.desktop.gaming;
in
{
  options = {
    modules.desktop.gaming.minecraft = {
      enable = mkEnableOption "Install Minecraft staff";
      enableMapRender = mkEnableOption "Enable BlueMap - Minecraft map render with Web UI";
    };
  };

  config = mkIf (cfg.enable && gamingCfg.enable) rec {
    # Minecraft launcher
    home-manager.users.wittano.home.packages = with unstable; [
      prismlauncher
    ];

    modules.desktop.gaming.games.installed = home-manager.users.wittano.home.packages ++ [
      "minecraft"
      "prismlauncher"
    ];

    modules.hardware.virtualization.stopServices = mkIf (cfg.enableMapRender) [{
      name = "win10";
      services = [ "render-bluemap-maps.service" ];
    }];

    # Minecraft development kit
    modules.dev.lang.ides = [ "jvm" ];

    # Minecraft map render
    services.bluemap = {
      enable = cfg.enableMapRender;
      eula = true;
    };
  };
}
