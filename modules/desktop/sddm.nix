{ config, pkgs, lib, privateRepo, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.sddm;
  splitByMinus = n: strings.splitString "-" n;

  pkgNames = attrsets.mapAttrsToList (_: v: if v ? pname then v.pname else v.name) privateRepo;
  sddmPkgNames = builtins.filter (x: builtins.any (e: e == "sddm") (splitByMinus x)) pkgNames;
  sddmThemeNames = builtins.map
    (x:
      let
        themeNameParts = splitByMinus (builtins.head (strings.splitString "sddm" x));
        themeName = lists.take ((builtins.length themeNameParts) - 1) themeNameParts;
      in
      strings.concatStringsSep "-" themeName)
    sddmPkgNames;
in
{

  options.modules.desktop.sddm = {
    enable = mkEnableOption "Enable SDDM as display manager";
    theme = mkOption {
      type = types.enum sddmThemeNames;
      default = "dexy";
      example = "wings";
      description = "SDDM theme from privateRepo";
    };
  };

  config = mkIf cfg.enable {
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
