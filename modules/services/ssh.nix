{ config, pkgs, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.services.ssh;
in {
  options = {
    modules.services.ssh = {
      enable = mkEnableOption ''
        Enable ssh
      '';
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings.RermitRootLogin = "no";
    };
  };
}
