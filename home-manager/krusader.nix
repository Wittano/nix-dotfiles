{ config, pkgs, lib, ... }: with lib;
let
  patchedKrusader = pkgs.krusader.overrideAttrs {
    postInstall = ''
      mkdir -p $out/etc/xdg/menus
      cp ${pkgs.libsForQt5.kservice}/etc/xdg/menus/applications.menu $out/etc/xdg/menus/applications.menu
    '';
  };
in
{
  options.programs.krusader.enable = mkEnableOption "krusader";

  config = mkIf config.programs.krusader.enable {
    home.packages =
      let
        kdePackage = with pkgs.kdePackages; [
          kde-cli-tools
        ];
      in
      with pkgs; [
        patchedKrusader
        krename
      ] ++ kdePackage;
  };
} 
