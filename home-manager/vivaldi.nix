{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  pwaAppFixer = pkgs.writeShellApplication {
    name = "vivaldi-pwa-fixer";
    runtimeInputs = with pkgs; [
      gnused
      coreutils
    ];
    text = ''
        findAnyVivaldiPWA=$(find "$HOME/.local/share/applications" -iname "vivaldi-*" -type f)
        if [ "$findAnyVivaldiPWA" == "" ]; then
            echo "Vivaldi PWA apps weren't found"
            exit 0
        fi

      for f in "$HOME/.local/share/applications"/vivaldi-*; do
          echo "Replace vivaldi PWA bin path: $f"

          sed -i "s/^Exec=\([a-z/0-9.-]*vivaldi\)/Exec=\/etc\/profiles\/per-user\/wittano\/bin\/vivaldi/" "$f"
      done
    '';
  };
in
{
  options.programs.vivaldi.wittano = {
    enable = mkEnableOption "vivaldi";
    enableAutostart = mkEnableOption "vivaldi on autostart";
  };

  config = mkIf config.programs.vivaldi.wittano.enable {
    home = {
      packages = with pkgs; [
        vivaldi
        vivaldi-ffmpeg-codecs
        pwaAppFixer
      ];
      activation.fixVivaldiPWAApps = lib.hm.dag.entryBefore [ "writeBoundary" ] (meta.getExe pwaAppFixer);
    };

    desktop.autostart.programs = mkIf config.programs.vivaldi.wittano.enableAutostart [ "vivaldi" ];
  };
}
