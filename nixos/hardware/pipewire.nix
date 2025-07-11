{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.pipewire.wittano;
in
{
  options.services.pipewire.wittano = {
    enable = mkEnableOption "Enable sound";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pulseaudio
      pavucontrol
    ];

    security.rtkit.enable = true;
    hardware.enableAllFirmware = cfg.enable;
    services.pipewire = rec {
      inherit (cfg) enable;

      alsa.enable = enable;
      alsa.support32Bit = enable;
      pulse.enable = enable;
    };
  };
}
