{ config, lib, pkgs, ... }: with lib; {
  options.programs.file-roller.enable = mkEnableOption "file-roller (archive file manager)";
  config = mkIf config.programs.file-roller.enable {
    home.packages = with pkgs; [
      file-roller
      unzip
      zip
      rar
      gzip
      gnutar
    ];
  };
}
