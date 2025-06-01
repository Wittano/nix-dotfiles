{ lib, config, pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.virtualisation.docker.wittano;
in
{
  options.virtualisation.docker.wittano = {
    enable = mkEnableOption "Enable Docker service";
    user = mkOption {
      type = types.str;
      default = "wittano";
      description = "Add access to docker group for specified user";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pass docker-credential-helpers ];

    hardware.virtualization.wittano.stopServices = [{
      name = "win10";
      services = [
        "docker.service"
        "docker.socket"
      ];
    }];

    virtualisation.docker = {
      enable = true;
      storageDriver = "overlay2";
      autoPrune = {
        enable = true;
        dates = "daily";
      };
    };

    users.users.${cfg.user}.extraGroups = [
      "docker"
    ];

    home-manager.users.${cfg.user}.programs.fish.shellAliases.ds =
      ''docker ps | cut -f 1 -d " " | tail -n +2 | xargs docker stop'';
  };
}

