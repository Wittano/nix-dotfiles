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

    home-manager.users.wittano.desktop.autostart.programs = [ "steam -silent" ];

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

    users = rec {
      groups.steam.gid = 2000;
      users.wittano.extraGroups = builtins.attrNames groups;
    };

    fileSystems = mkIf cfg.disk.enable {
      "${cfg.disk.path}" = {
        device = "/dev/disk/by-label/GAMING";
        fsType = "ext4";
      };
    };
  };

}
