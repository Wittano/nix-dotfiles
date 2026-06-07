{ config, lib, pkgs, ... }: with lib; {
  options.boot.plymouth.wittano.enable = mkEnableOption "plymouth - booting splash screen";

  config = {
    boot.plymouth = {
      enable = config.boot.plymouth.wittano.enable;
      themePackages = with pkgs; [ nixos-blur-playmouth ];
      theme = "nixos-blur";
    };
  };
}
