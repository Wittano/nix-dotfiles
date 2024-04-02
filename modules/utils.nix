{ config, lib, pkgs, privateRepo, ... }:
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
    home-manager.users.wittano.home.packages = mkIf (cfg.enable) (with privateRepo; [patcherDir]);
    environment.systemPackages = mkIf (cfg.enableGlobalUtils) (with pkgs; [ btop ]);
  };
}
