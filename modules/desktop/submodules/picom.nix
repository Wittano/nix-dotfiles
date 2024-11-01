{ pkgs, lib, config, ... }:
with lib;
with lib.my;
let
  guardName = "gaming-picom-guard";
  gameStaff = bash.mkBashArray (builtins.map (x: x.pname or x.name or x) config.modules.desktop.gaming.games.picomExceptions);
in
{
  config = rec {
    systemd.user.services.${guardName} = {
      enable = config.services.picom.package != pkgs.picom;
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "picom.service" ];
      path = with pkgs; [ systemd toybox ];
      script = /*bash*/''
        arr=(${gameStaff})

        while true; do
          for g in "''${arr[@]}"; do
            if pgrep --ignore-case "''$g" > /dev/null; then
              systemctl --user stop picom.service
              exit
            fi
          done

          if ! systemctl --user is-active picom.service > /dev/null; then
            systemctl --user start picom.service
          fi
        done
      '';
      startAt = "*-*-* *:*:00";

      serviceConfig.ExecCondition = meta.getExe (pkgs.writeShellApplication {
        name = "check-games-staff";
        runtimeInputs = with pkgs; [ toybox ];
        text = ''
          arr=(${gameStaff})
            for g in "''${arr[@]}"; do
              if pgrep --ignore-case "''$g"; then
                exit 0
              fi
            done
        '';
      });
    };

    services.picom = {
      enable = true;
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
