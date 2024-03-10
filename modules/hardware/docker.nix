{ pkgs, lib, config, ... }:
with lib;
with builtins;
let
  cfg = config.modules.hardware.docker;
in
{
  options = {
    modules.hardware.docker = {
      enable = mkEnableOption "Enable Docker service";
    };
  };

  config = mkIf (cfg.enable) {
    virtualisation.docker.enable = true;
    users.users.wittano.extraGroups = [
      "docker"
    ];
  };
}

