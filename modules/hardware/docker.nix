{ pkgs, lib, config, home-manager, ... }:
with lib;
with lib.my;
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
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "daily";
      };
    };
    users.users.wittano.extraGroups = [
      "docker"
    ];

    home-manager.users.wittano.programs.fish.shellAliases.ds =
      ''docker ps | cut -f 1 -d " " | tail -n +2 | xargs docker stop'';
  };
}

