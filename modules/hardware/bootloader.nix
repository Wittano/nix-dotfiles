{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.grub;
in
{
  options = {
    modules.hardware.grub = {
      enable = mkEnableOption "Enable GRUB2 as bootloader";
      theme = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = pkgs.nixos-grub2-theme;
        description = "Set GRUB theme";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      splashImage = "${cfg.theme}/background.png";
      efiSupport = true;
      enable = true;
      theme = cfg.theme;
      device = "nodev";
    };
  };
}
