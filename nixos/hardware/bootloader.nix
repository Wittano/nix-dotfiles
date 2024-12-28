{ config, lib, inputs, ... }:
with lib;
let
  cfg = config.boot.loader.grub.wittano;
  theme = inputs.honkai-railway-grub-theme.packages.x86_64-linux.dr_ratio-grub-theme;
in
{
  options.boot.loader.grub.wittano = {
    enable = mkEnableOption "Enable GRUB2 as bootloader";
    enableMultiBoot = mkEnableOption "Enable os-probe to detect other systems";
  };

  config = {
    boot.loader.grub = rec {
      inherit theme;
      inherit (cfg) enable;

      splashImage = "${theme}/background.png";
      efiSupport = enable;
      device = "nodev";
      useOSProber = cfg.enableMultiBoot;
    };
  };
}
