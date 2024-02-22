{ config, lib, privateRepo, ... }:
with lib;
with lib.my;
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
    environment.systemPackages = mkIf (cfg.enableGlobalUtils) ([ privateRepo.patcherDir ]);
  };
}
