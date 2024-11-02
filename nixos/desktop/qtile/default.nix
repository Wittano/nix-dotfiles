{ config, pkgs, lib, ... }:
with lib;
{
  options.desktop.qtile.enable = mkEnableOption "qtile desktop";

  config = mkIf config.desktop.qtile.enable {
    fonts.packages = with pkgs; [ nerdfonts jetbrains-mono ];

    services.xserver = {
      enable = true;
      windowManager.qtile.enable = true;
    };
  };
}
