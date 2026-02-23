{ config, lib, ... }: with lib; {
  options.programs.ghostty.wittano.enable = mkEnableOption "ghostty";

  config = mkIf config.programs.ghostty.wittano.enable {
    catppuccin.ghostty.enable = true;

    programs.ghostty = {
      enable = true;
      enableFishIntegration = config.programs.fish.enable;

      systemd.enable = true;

      settings = {
        font-size = 18;
        font-family = "font-family";
        link-url = true;
        link-previews = true;
        working-directory = "inherit";
        confirm-close-surface = false;
        linux-cgroup = "single-instance";
        keybind = [
          "ctrl+h=goto_split:left"
          "ctrl+l=goto_split:right"
        ];
      };
    };
  };
}
