{ config, lib, pkgs, ... }: with lib; {
  options.programs.nemo.enable = mkEnableOption "nemo file manager";

  config = mkIf config.programs.nemo.enable {
    home.packages = with pkgs; [ nemo file-roller file-rename ];
  };
}
