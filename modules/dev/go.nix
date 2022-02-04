{ config, pkgs, unstable, lib, home-manager, ... }:
with lib;
let cfg = config.modules.dev.go;
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
    home-manager.users.wittano.home.packages = with pkgs;
      [ unstable."go_1_${cfg.version}" ]
      ++ (if cfg.useGoland then [ jetbrains.goland gnumake gcc ] else [ ]);
  };

}
