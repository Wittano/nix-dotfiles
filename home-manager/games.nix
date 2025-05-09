{ lib, config, pkgs, unstable ? pkgs, ... }:
with lib;
with lib.my;
let
  cfg = config.programs.games;

  games = with unstable; [
    # Games
    osu-lazer # osu!lazer
    # airshipper # Veloren
    mindustry # Mindustry
    xivlauncher # FF XIV
    prismlauncher # Minecraft
    zeroad-unwrapped # 0 A.D
  ];

  fixAge2Sync = pkgs.writeShellApplication {
    name = "fixAge2Sync";
    runtimeInputs = with pkgs; [ wget cabextract coreutils sudo ];
    text = builtins.readFile ./scripts/fixAge2Sync.sh;
    runtimeEnv = {
      STEAM_GAME_DIR = "/mnt/gaming/SteamLibrary";
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

  patches = [
    fixDarksiders
    fixAge2Sync
    fixSteamSystemTray
  ];
in
{
  options.programs.games = {
    enable = mkEnableOption "Install unrelated(with Steam, lutris or other launchers) games";
    enableDev = mkEnableOption "Enable developer tools to moddling games";
  };

  config = mkIf cfg.enable {
    home.packages = games ++ patches ++ (with pkgs; [
      spotify

      # Social media
      telegram-desktop
      signal-desktop
    ]);

    programs.jetbrains.ides = mkIf cfg.enableDev [ "jvm" "dotnet" ];

    desktop.autostart.programs = [
      "signal-desktop --start-in-tray"
      "telegram-desktop -startintray"
      "spotify"
      "steam -silent"
    ];

    services.picom.wittano.exceptions = games ++ [
      "\.exe$"
      "XIVlauncher.Core"
    ];
  };
}
