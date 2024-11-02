{ lib, config, ... }:
with lib;
with lib.my;
{
  options.virtualisation.docker.wittano.enable = mkEnableOption "Enable Docker service";

  config = mkIf config.virtualisation.docker.wittano.enable {
    hardware.virtualization.wittano.stopServices = [{
      name = "win10";
      services = [
        "docker.service"
        "docker.socket"
      ];
    }];

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

