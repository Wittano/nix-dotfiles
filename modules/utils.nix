{ config, lib, pkgs, privateRepo, unstable, ... }:
with lib;
with lib.my;
let
  patcherDir = unstable.writeShellApplication {
    name = "patcherDir";
    runtimeInputs = with pkgs; [ findutils file gnugrep coreutils patchelf ];
    text = builtins.readFile ./utils/patcherDir.sh;
    runtimeEnv = {
      GLIB_PATH = "${pkgs.glibc}/lib/ld-linux-x86-64.so.2";
    };
  };

  cfg = config.modules.utils;
in
{
  options = {
    modules.utils = {
      enable = mkEnableOption "Enable utilities programs (per-users)";
      enableGlobalUtils = mkEnableOption "Enable utilities programs (global)";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.wittano.home.packages = mkIf (cfg.enable) [ patcherDir ];
    environment.systemPackages = mkIf (cfg.enableGlobalUtils) (with pkgs; [ btop ]);
  };
}
