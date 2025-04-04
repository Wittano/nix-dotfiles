{ lib, config, ... }:
with lib;
with lib.my;
let
  cfg = config.virtualisation.podman.wittano;
in
{
  options.virtualisation.podman.wittano = {
    enable = mkEnableOption "Podman contenerization";
  };

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "daily";
      };
    };
  };
}

