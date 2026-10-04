{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  waylandPlugins = lists.optionals (!config.services.xserver.enable) [
    pkgs.obs-studio-plugins.wlrobs
  ];
in
{
  options.programs.obs-studio.wittano.enable = mkEnableOption "osb-studio with plugins";

  config = mkIf config.programs.obs-studio.wittano.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = config.programs.droidcam.enable;
      plugins = waylandPlugins;
    };
  };
}
