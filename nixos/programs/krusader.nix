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
    services.locate = {
      enable = true;
      interval = "18:00";
    };

    environment.systemPackages =
      let
        kdePackage = with pkgs.kdePackages; [
          kde-cli-tools
          kget
        ];
      in
      with pkgs; [
        patchedKrusader
        krename
        bzip2
        cpio
        coreutils
        gnutar
        gzip
        xz
        xxdiff
        busybox
        p7zip
        arj
        lhasa
        rar
        unzip
        zip
      ] ++ kdePackage;
  };
} 
