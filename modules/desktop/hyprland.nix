{ config, pkgs, lib, dotfiles, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Enable Hyperland(Wayland) desktop";
  };

  config = mkIf cfg.enable {
    programs.hyprland = rec {
      enable = true;
      xwayland.enable = enable;
      nvidiaPatches = config.modules.hardware.nvidia.enable;
    };
  };
}
