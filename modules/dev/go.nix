{ config, pkgs, unstable, lib, home-manager, ... }:
with lib;
let
  cfg = config.modules.dev.go;
  goVersion = "20";
in
{
  options = {
    modules.dev.go = {
      enable = mkEnableOption ''
        Enable goland as user package
      '';
    };

    config = mkIf cfg.enable {
      home-manager.users.wittano.home.packages = with pkgs;
        [ unstable.go ]
        ++ (if cfg.useGoland then [ jetbrains.goland gnumake gcc ] else [ ]);
    };

  };
}
