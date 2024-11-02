{ config, lib, pkgs, unstable, ... }:
with lib;
let
  cfg = config.programs.steam.wittano;
in
{

  options.programs.steam.wittano = {
    enable = mkEnableOption "steam and scripts for games installed via Steam";
    disk = {
      enable = mkEnableOption "Add special disk to configuration";
      path = mkOption {
        type = types.str;
        default = "/mnt/gaming";
        description = "Path to mounted additional disk";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = unstable.steam;
    };

    environment.systemPackages = with unstable; [
      # Steam staff
      gamescope
      gamemode
    ];

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        wineWowPackages.full
      ];
    };
  };

}
