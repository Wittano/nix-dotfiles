{ config, pkgs, lib, privateRepo, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.sddm;
in {

  options.modules.desktop.sddm = {
    enable = mkEnableOption "Enable SDDM as display manager";
    theme = mkOption {
      type = types.str;
      default = "dexy";
      example = "wings";
      description = ''
        SDDM theme from Wittano nix-repo(https://github.com/Wittano/nix-repo)
      '';
    };
  };

  config = mkIf cfg.enable {
    # TODO export additional runtime dependecy for themes, after upgrade system to NixOS 24.05
    environment.systemPackages =
      let
        themes = [ privateRepo."${cfg.theme}" ];
        qt6Deps = with pkgs.qt6; [ qtbase ];
        gstreamerDeps = with pkgs.gst_all_1; [
          gstreamer
          gst-plugins-ugly
          gst-plugins-bad
          gst-plugins-good
          gst-plugins-base
          gst-libav
        ];
        plasmaDeps = with pkgs.libsForQt5; [
          plasma-framework
          plasma-workspace
        ];
        qt5Deps = with pkgs.libsForQt5.qt5; [
          qtgraphicaleffects
          qtquickcontrols2
          qtbase
          qtsvg
          qtmultimedia
          pkgs.libsForQt5.phonon-backend-gstreamer
        ];
      in
      themes ++ qt6Deps ++ qt5Deps ++ gstreamerDeps ++ plasmaDeps;

    services.xserver.displayManager.sddm = {
      enable = cfg.enable;
      theme = cfg.theme;
      autoNumlock = true;
    };

  };

}
