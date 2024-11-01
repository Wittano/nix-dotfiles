{ config, lib, pkgs, unstable, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.gaming.steam;
  gamingCfg = config.modules.desktop.gaming;

  fixAge2Sync = pkgs.writeShellApplication {
    name = "fixAge2Sync";
    runtimeInputs = with pkgs; [ wget cabextract coreutils sudo ];
    text = builtins.readFile ./scripts/fixAge2Sync.sh;
    runtimeEnv = {
      STEAM_GAME_DIR = gamingCfg.disk.path;
    };
  };
  fixSteamSystemTray = pkgs.writeScriptBin "fixSteamSystemTray"
    "rm -rf ~/.local/share/Steam/ubuntu12_32/steam-runtime/pinned_libs_{32,64}";

  fixDarksiders =
    let
      repo = pkgs.srcOnly {
        name = "mf-installcab_steamdeck";
        version = "08-11-2023";
        src = pkgs.fetchFromGitLab {
          repo = "mf-installcab_steamdeck";
          owner = "steevyp";
          rev = "c7b89af844d056eb0d5d700ae702b9581094d017";
          sha256 = "sha256-8UlZcELv0JLmjymucYV/Wq/2C+M+PT6ETKa6EZssJpU=";
        };

        patches = [ ./patches/fix-darksiders.patch ];
      };
    in
    pkgs.writeShellApplication {
      name = "fix-darksiders";
      runtimeInputs = with pkgs; [ python3 coreutils toybox cabextract wget ];
      runtimeEnv = {
        PROTON = "/mnt/gaming/SteamLibrary/steamapps/common/Proton 8.0";
        WINEPREFIX = "/mnt/gaming/SteamLibrary/steamapps/compatdata/462780/pfx";
        SCRIPTDIR = builtins.toString repo;
        GAME_EXE = "/mnt/gaming/SteamLibrary/steamapps/common/Darksiders Warmastered Edition";
      };
      text = builtins.readFile (repo + "/install-mf-64.sh");
    };
in
{

  options.modules.desktop.gaming.steam = {
    enable = mkEnableOption "Enable steam and scripts for games installed via Steam";
    enableScripts = mkEnableOption "Install custom script to fix games e.g. Age of Empier, Steam systray icon or Darksider 1";
    enableDev = mkEnableOption "Enable developer tools to moddling games";
  };

  config = mkIf (cfg.enable && gamingCfg.enable) rec {
    programs.steam = {
      enable = true;
      package = unstable.steam;
    };

    modules.desktop.gaming.games.picomExceptions = [
      programs.steam.package
    ];

    modules.shell.fish.completions."mf-fix" = ''
      complete -c mf-fix -s v -l verbose --no-files
      complete -c mf-fix -s h -l help --no-files
      complete -c mf-fix -s e -l executable -F -r
      complete -c mf-fix -s n -l noconfirm --no-files
    '';

    home-manager.users.wittano.home.packages = with unstable; [
      # Games scripts
      fixDarksiders
      fixAge2Sync
      fixSteamSystemTray

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

    # Modding and game staff tool
    modules.dev.lang.ides = mkIf cfg.enableDev [ "dotnet" ];
  };

}
