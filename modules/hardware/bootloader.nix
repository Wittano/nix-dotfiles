{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
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
    boot.loader.grub = {
      efiSupport = true;
      enable = true;
      useOSProber = true;
      device = "nodev";
    };
  };
}
