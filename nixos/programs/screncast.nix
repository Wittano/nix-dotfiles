{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      slurp
      grim
      wl-clipboard
    ];
    text = "slurp | grim -g - - | wl-copy";
  };
in
{
  options.programs.screencast.enable = mkEnableOption "screencast and screenshot on wayland";

  config = mkIf config.programs.screencast.enable {
    environment.systemPackages = [ screenshot ];

    xdg.portal = {
      enable = true;
      wlr = {
        enable = true;
        settings.screencast = {
          output_name = "HDMI-A-1";
          max_fps = 60;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f 'Monitor: %o' -or";
        };
      };
    };
  };
}
