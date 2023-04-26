{ config, pkgs, lib, ownPackages, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.sddm;
in
{

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

  config = mkIf (cfg.enable) {
    environment.systemPackages = with ownPackages; [
      "${cfg.theme}"
    ];

    services.xserver.displayManager.sddm = {
      enable = cfg.enable;
      theme = cfg.theme;
      autoNumlock = true;
    };

  };

}
