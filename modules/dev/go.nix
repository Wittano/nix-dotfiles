{ config, pkgs, unstable, lib, home-manager, mainUser, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf types;

  cfg = config.modules.dev.go;
  golandPackages = with pkgs; [ jetbrains.goland gnumake gcc ];
in {
  options = {
    modules.dev.go = {
      enable = mkEnableOption ''
        Enable goland as user package
      '';

      version = mkOption {
        type = types.str;
        default = "17";
        example = "15";
        description = ''
          Selected version of go
        '';
      };

      useGoland = mkEnableOption ''
        Added Goland IDE as default Go editor
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${mainUser}.home.packages = with pkgs; [
      unstable."go_1_${cfg.version}"

      (mkIf cfg.useGoland golandPackages)
    ];
  };

}
