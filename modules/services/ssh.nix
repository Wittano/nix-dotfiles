{ config, pkgs, lib, ... }:
with lib;
with lib.my;
let
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
      settings.PermitRootLogin = "no";
    };
  };
}
