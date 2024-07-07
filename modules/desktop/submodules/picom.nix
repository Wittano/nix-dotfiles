{ pkgs, ... }:
{
  config = {
    services.picom = {
      enable = true;
      package = pkgs.picom-allusive;
      backend = "glx";
      fade = true;
      fadeDelta = 4;

      vSync = true;

      wintypes = {
        dock.shadow = false;
        notification.corner-radius = 5;
      };

      opacityRules = [
        "95:class_g = 'Alacritty' && focused"
        "85:class_g = 'Alacritty' && !focused"
        "95:class_g = 'kitty' && focused"
        "85:class_g = 'kitty' && !focused"
      ];

      settings = {
        glx-no-stencil = true;
        glx-copy-from-front = false;

        # Border
        corner-radius = 10;
        corners-rule = [
          "10:class_g = 'xmobar'"
        ];
        round-borders = 3;

        # Blur
        blur-background = true;
        blur-method = "gaussian";
        blur-strength = 6;
        blur-background-exclude = [
          "window_type = 'dock'"
        ];

        dbus = true;

        # Fade
        no-fading-openclose = false;

        # Other
        mark-wmwin-focused = true;
        mark-ovredir-focused = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        refresh-rate = 0;
        dbe = false;
        unredir-if-possible = false;
        detect-transient = true;
        detect-client-leader = true;
        use-damage = true;
        xrender-sync-fence = true;
      };
    };
  };
}
