{ config, pkgs, lib, ... }: with lib; {
  options.services.betterlockscreen.wittano.enable = mkEnableOption "betterlockscreen";
  config = mkIf config.services.betterlockscreen.wittano.enable {
    home.packages = with pkgs; [ betterlockscreen ];
  };
}
