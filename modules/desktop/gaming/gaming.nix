{ config, pkgs, lib, unstable, ... }:
with lib;
let
  cfg = config.modules.desktop.gaming;
  homeDir = config.home-manager.users.wittano.home.homeDirectory;

  steamGamingDir = if cfg.disk.enable then cfg.disk.path else "${homeDir}/.steam/steam";

  fixedMindustry = pkgs.mindustry.override {
    gradle = pkgs.gradle_7;
  };
in
{
  options = {
    modules.desktop.gaming = {
      enable = mkEnableOption "Enable games";
      disk = {
        enable = mkEnableOption "Add special disk to configuration";
        path = mkOption {
          type = types.str;
          default = "/mnt/gaming";
          description = "Path to mounted additional disk";
        };
      };
      enableMihoyoGames = mkEnableOption "Install Genshin Impact and Honkai Railway";
    };
  };

  config = mkIf cfg.enable {
    # Genshin Impact
    programs.anime-game-launcher.enable = cfg.enableMihoyoGames;

    # Honkai Railway
    programs.honkers-railway-launcher.enable = cfg.enableMihoyoGames;

    home-manager.users.wittano = {
      gtk.gtk3.bookmarks = mkIf (cfg.disk.enable) [ "file://${steamGamingDir} Gaming" ];
      home.packages = with unstable; [
        # Lutris
        lutris
        xdelta
        xterm
        gnome.zenity

        # Wine
        wineWowPackages.full

        # FSH
        steam-run

        # Games
        prismlauncher # Minecraft launcher
        xivlauncher # FFXIV launcher
        unstable.osu-lazer # osu!lazer
        airshipper # Veloren
        fixedMindustry # Mindustry
      ];
    };

    boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_stable;

    programs.steam = {
      enable = true;
      package = unstable.steam;
    };

    fileSystems = mkIf (cfg.disk.enable) {
      "${steamGamingDir}" = {
        device = "/dev/disk/by-label/GAMING";
        fsType = "ext4";
      };
    };
  };
}
