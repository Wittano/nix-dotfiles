{ config, lib, ... }:
with lib;
let
  cfg = config.sound.wittano;
in
{
  options.sound.wittano = {
    enable = mkEnableOption "Enable sound";
    driver = mkOption {
      type = types.enum [ "pulseaudio" "pipewire" ];
      default = "pulseaudio";
      example = "pipewire";
      description = "Select sound driver";
    };
  };

  config = mkIf cfg.enable {
    sound.enable = true;

    hardware.pulseaudio = rec {
      enable = cfg.driver == "pulseaudio";
      support32Bit = enable;
    };

    security.rtkit.enable = true;
    services.pipewire = rec {
      enable = cfg.driver == "pipewire";
      alsa.enable = enable;
      alsa.support32Bit = enable;
      pulse.enable = enable;
    };
  };
}
