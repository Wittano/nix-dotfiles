{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.hardware.sound;
in {
  options = {
    modules.hardware.sound = {
      enable = mkEnableOption "Enable sound";
      driver = mkOption {
        type = types.enum [ "pulseaudio" "pipewire" ];
        default = "pulseaudio";
        example = "pipewire";
        description = "Select sound driver";
      };
    };
  };

  config = mkIf cfg.enable {
    sound.enable = true;

    hardware.pulseaudio = rec {
      enable = cfg.driver == "pulseaudio";
      support32Bit = enable;
    };

    security.rtkit.enable = true;
    services.pipewire = let pipewireEnable = cfg.driver == "pipewire";
    in {
      enable = pipewireEnable;
      alsa.enable = pipewireEnable;
      alsa.support32Bit = pipewireEnable;
      pulse.enable = pipewireEnable;
    };
  };
}
