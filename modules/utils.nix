{ config, pkgs, lib, home-manager, privateRepo, ... }:
with lib;
let cfg = config.modules.utils;
in {
  options = {
    modules.utils = {
      enable = mkEnableOption ''
        Enable utilities programs (per-users)
      '';
      enableGlobalUtils = mkEnableOption ''
        Enable utilities programs (global)
      '';
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = mkIf (cfg.enable) ([ ]);

    environment.systemPackages =
      mkIf (cfg.enableGlobalUtils) ([ privateRepo.patcherDir ]);
  };
}
