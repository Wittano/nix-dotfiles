{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  ffmpeg = config.programs.ffmpeg.packages.override rec {
    withAlsa = config.hardware.alsa.enable;
    withAmf = config.hardware.amd.enable;
    withJack = config.services.jack.jackd.enable;
    withNpp = config.hardware.nvidia.wittano.enable;
    withOpengl = true;
    withPulse = config.services.pulseaudio.enable;
    withSamba = true;
    withSvg = true;
    withVulkan = true;
    withXcb = !config.desktop.labwc.enable;
    withXcbShape = withXcb;
    withXcbShm = withXcb;
    withXcbxfixes = withXcb;
    withXlib = withXcb;
  };
in
{
  options.programs.ffmpeg = {
    enable = mkEnableOption "ffmpeg with custom flags";
    packages = mkOption {
      type = types.package;
      description = "FFMPEG package";
      default = pkgs.ffmpeg;
    };
  };
  config = mkIf config.programs.ffmpeg.enable {
    hardware.enableRedistributableFirmware = true;

    environment.systemPackages = [ ffmpeg ];
  };
}
