{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.modules.hardware.sound;
in {
  options = {
    modules.hardware.sound = {
      enable = mkEnableOption ''
        Enable sound
      '';
    };
  };

  config = mkIf cfg.enable {
    sound.enable = true;

    hardware.pulseaudio = rec {
      enable = true;
      support32Bit = enable;
    };
  };
}
