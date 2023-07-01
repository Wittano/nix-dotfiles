{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.hardware.grub;
in {
  options = {
    modules.hardware.grub = {
      enable = mkEnableOption ''
        Enable GRUB2 as bootloader
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {

      grub = {
        efiSupport = true;
        enable = true;
        useOSProber = true;
        device = "nodev";
      };
    };
  };
}
