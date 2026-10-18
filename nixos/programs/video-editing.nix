{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
with lib;
{
  options.programs.video-edititng.enable = mkEnableOption "video-editing tools";

  config = mkIf config.programs.video-edititng.enable {
    home-manager.users.wittano.home.packages = with pkgs; [
      kdePackages.kdenlive
      audacity
      unstable.helvum
    ];

    programs = {
      noisetorch.enable = true;
      ffmpeg.enable = true;
      python = {
        pythonPackages = [
          "opencv-python"
          "sam2"
          "opencv-python-headless"
        ];
        packages = with pkgs; [
          opencv
        ];
      };
    };
  };
}
