{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.boot.loader.grub.wittano;
in
{
  options.boot.loader.grub.wittano = {
    enable = mkEnableOption "Enable GRUB2 as bootloader";
    theme = mkOption {
      type = types.nullOr types.package;
      default = null;
      example = pkgs.nixos-grub2-theme;
      description = "Set GRUB theme";
    };
    enableMultiBoot = mkEnableOption "Enable os-probe to detect other systems";
  };

  config = {
    boot.loader.grub = rec {
      splashImage = mkIf (cfg.theme != null) "${cfg.theme}/background.png";
      efiSupport = enable;
      enable = cfg.enable;
      theme = cfg.theme;
      device = "nodev";
      useOSProber = cfg.enableMultiBoot;
    };
  };
}
